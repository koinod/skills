#!/usr/bin/env node

/**
 * Autonomous Operator — Sovereign Business Infrastructure
 * Manages email independence, local LLM, self-monitoring, and autonomous loops.
 */

const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const http = require('http');

const CONFIG_DIR = path.join(process.env.HOME, '.autonomous-operator');
const STATE_FILE = path.join(CONFIG_DIR, 'state.json');
const LOG_FILE = path.join(CONFIG_DIR, 'autonomous.log');

const DEFAULT_CONFIG = {
  emailBackends: ['gog', 'smtp', 'api', 'draft'],
  llmModel: 'llama3.2',
  reportTime: '09:00',
  followupIntervalHours: 2,
  monitoringPort: 31415,
  enableDashboard: true
};

class AutonomousOperator {
  constructor() {
    this.config = { ...DEFAULT_CONFIG };
    this.state = this.loadState();
    this.ollamaInstalled = false;
    this.emailBackend = null;
    this.running = true;
    this.setupGracefulShutdown();
  }

  log(level, msg) {
    const timestamp = new Date().toISOString();
    console.log(`[${timestamp}] [${level}] ${msg}`);
    fs.appendFileSync(LOG_FILE, `[${timestamp}] [${level}] ${msg}\n`);
  }

  loadState() {
    if (!fs.existsSync(CONFIG_DIR)) fs.mkdirSync(CONFIG_DIR, { recursive: true });
    if (fs.existsSync(STATE_FILE)) {
      return JSON.parse(fs.readFileSync(STATE_FILE, 'utf8'));
    }
    return { revenue: { leads: 0, emailsSent: 0, replies: 0, callsBooked: 0, dealsClosed: 0 }, lastRun: {}, alerts: [] };
  }

  saveState() {
    fs.writeFileSync(STATE_FILE, JSON.stringify(this.state, null, 2));
  }

  setupGracefulShutdown() {
    process.on('SIGINT', () => this.shutdown());
    process.on('SIGTERM', () => this.shutdown());
  }

  async shutdown() {
    this.log('INFO', 'Shutting down autonomous operator...');
    this.running = false;
    this.saveState();
    process.exit(0);
  }

  // ==================== EMAIL INDEPENDENCE ====================

  detectEmailBackends() {
    const available = [];
    // Check gog
    try {
      const result = spawnSync('which', ['gog']);
      if (result.status === 0) available.push('gog');
    } catch (e) {}
    // Check SMTP (python or sendmail)
    try {
      const py = spawnSync('which', ['python3']);
      if (py.status === 0) available.push('smtp');
    } catch (e) {}
    // Check common APIs via env vars
    if (process.env.SENDGRID_API_KEY) available.push('sendgrid');
    if (process.env.MAILGUN_API_KEY) available.push('mailgun');
    // Always can draft
    available.push('draft');
    this.log('INFO', `Detected email backends: ${available.join(', ')}`);
    return available;
  }

  selectEmailBackend() {
    const available = this.detectEmailBackends();
    for (const backend of this.config.emailBackends) {
      if (available.includes(backend)) {
        this.emailBackend = backend;
        this.log('INFO', `Selected email backend: ${backend}`);
        return backend;
      }
    }
    this.log('WARN', 'No suitable email backend found; will use draft mode');
    this.emailBackend = 'draft';
    return 'draft';
  }

  async sendEmail(to, subject, body, attachments = []) {
    this.log('INFO', `Sending email to ${to} via ${this.emailBackend}`);
    this.state.revenue.emailsSent = (this.state.revenue.emailsSent || 0) + 1;
    this.saveState();

    switch (this.emailBackend) {
      case 'gog':
        return this.sendViaGog(to, subject, body, attachments);
      case 'smtp':
        return this.sendViaSMTP(to, subject, body, attachments);
      case 'sendgrid':
        return this.sendViaSendGrid(to, subject, body, attachments);
      case 'draft':
      default:
        this.log('INFO', `Draft email prepared for ${to} (subject: ${subject})`);
        return { status: 'drafted', to, subject };
    }
  }

  sendViaGog(to, subject, body, attachments) {
    // Use gog CLI if authenticated
    try {
      const result = spawnSync('gog', ['gmail', 'send', '--to', to, '--subject', subject, '--body', body]);
      if (result.status === 0) {
        this.log('INFO', `Email sent via gog to ${to}`);
        return { status: 'sent', to, subject };
      } else {
        throw new Error(result.stderr?.toString() || 'gog failed');
      }
    } catch (e) {
      this.log('ERROR', `gog send failed: ${e.message}. Falling back to draft.`);
      return { status: 'draft', to, subject, error: e.message };
    }
  }

  sendViaSMTP(to, subject, body, attachments) {
    // Use Python smtplib with app password if credentials exist
    const script = `
import smtplib, ssl, os
sender = '${process.env.AUTONOMOUS_SMTP_USER || 'iankmeeks@gmail.com'}'
password = os.getenv('AUTONOMOUS_SMTP_PASS', '')
receiver = '${to}'
message = f\"\"\"From: Autonomous Operator <{sender}>
To: {to}
Subject: {subject}

{body}
\"\"\"
context = ssl.create_default_context()
try:
    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls(context=context)
    server.login(sender, password)
    server.sendmail(sender, receiver, message)
    server.quit()
    print('SENT')
except Exception as e:
    print('ERROR:', e)
`;
    try {
      const result = spawnSync('python3', ['-c', script], { env: { ...process.env, AUTONOMOUS_SMTP_USER: process.env.AUTONOMOUS_SMTP_USER, AUTONOMOUS_SMTP_PASS: process.env.AUTONOMOUS_SMTP_PASS } });
      if (result.stdout.toString().includes('SENT')) {
        this.log('INFO', `Email sent via SMTP to ${to}`);
        return { status: 'sent', to, subject };
      } else {
        throw new Error(result.stderr?.toString() || 'SMTP failed');
      }
    } catch (e) {
      this.log('ERROR', `SMTP send failed: ${e.message}. Falling back to draft.`);
      return { status: 'draft', to, subject, error: e.message };
    }
  }

  sendViaSendGrid(to, subject, body, attachments) {
    // Future: implement SendGrid API
    return { status: 'draft', to, subject, error: 'SendGrid not implemented yet' };
  }

  // ==================== LOCAL LLM ====================

  async ensureLocalLLM() {
    try {
      const result = spawnSync('which', ['ollama']);
      if (result.status !== 0) {
        this.log('INFO', 'Ollama not found; attempting to install via brew...');
        spawnSync('brew', ['install', 'ollama'], { stdio: 'inherit' });
      }
      // Check if ollama service is running
      const runResult = spawnSync('ollama', ['list']);
      if (runResult.status !== 0) {
        this.log('INFO', 'Starting ollama service...');
        spawnSync('ollama', ['serve'], { stdio: 'ignore', detached: true });
        // Wait a moment
        await new Promise(resolve => setTimeout(resolve, 3000));
      }
      // Pull the desired model if not present
      const model = this.config.llmModel;
      const listResult = spawnSync('ollama', ['list']);
      if (!listResult.stdout.toString().includes(model)) {
        this.log('INFO', `Pulling ${model} from Ollama (this may take a while)...`);
        spawnSync('ollama', ['pull', model], { stdio: 'inherit' });
      }
      this.ollamaInstalled = true;
      this.log('INFO', `Local LLM ${model} ready`);
    } catch (e) {
      this.log('ERROR', `Local LLM setup failed: ${e.message}. Will use cloud APIs.`);
    }
  }

  async queryLocalLLM(prompt, system = 'You are a helpful AI assistant.') {
    if (!this.ollamaInstalled) await this.ensureLocalLLM();
    try {
      const response = spawnSync('ollama', ['run', this.config.llmModel, prompt]);
      return response.stdout.toString().trim();
    } catch (e) {
      this.log('ERROR', `Local LLM query failed: ${e.message}`);
      return null;
    }
  }

  // ==================== SELF-MONITORING ====================

  generateReport() {
    const revenue = this.state.revenue;
    const pipeline = `Leads: ${revenue.leads} | Emails: ${revenue.emailsSent} | Replies: ${revenue.replies} | Calls: ${revenue.callsBooked} | Closed: ${revenue.dealsClosed}`;
    const last24h = new Date(Date.now() - 24*60*60*1000);
    const recent = this.state.lastRun && this.state.lastRun.timestamp > last24h.toISOString();
    const status = {
      timestamp: new Date().toISOString(),
      revenuePipeline: pipeline,
      emailBackend: this.emailBackend,
      localLLM: this.ollamaInstalled ? 'ready' : 'unavailable',
      recentActivity: recent,
      alerts: this.state.alerts || []
    };
    return status;
  }

  // ==================== AUTONOMOUS LOOPS ====================

  async runFollowupCycle() {
    this.log('INFO', 'Running autonomous follow-up cycle...');
    // TODO: load leads from research/ready-to-send.md or CRM
    // send scheduled follow-ups based on sequence
    // update lead status
    // For now, just log
    this.log('INFO', 'Follow-up cycle complete');
    this.state.lastRun.followup = new Date().toISOString();
    this.saveState();
  }

  async runDailyReport() {
    const now = new Date();
    const reportTime = this.config.reportTime.split(':');
    if (now.getHours() === parseInt(reportTime[0]) && now.getMinutes() === parseInt(reportTime[1])) {
      const report = this.generateReport();
      this.log('INFO', `Daily Report: ${JSON.stringify(report, null, 2)}`);
      // Could send to Ian via email or store in file
      fs.writeFileSync(path.join(CONFIG_DIR, 'daily-report.json'), JSON.stringify(report, null, 2));
    }
  }

  // ==================== DASHBOARD ====================

  startDashboard() {
    if (!this.config.enableDashboard) return;
    const server = http.createServer((req, res) => {
      if (req.url === '/status' || req.url === '/') {
        const report = this.generateReport();
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(report, null, 2));
      } else if (req.url === '/health') {
        res.writeHead(200);
        res.end('OK');
      } else {
        res.writeHead(404);
        res.end('Not found');
      }
    });
    server.listen(this.config.monitoringPort, () => {
      this.log('INFO', `Dashboard listening on http://localhost:${this.config.monitoringPort}/status`);
    });
  }

  // ==================== MAIN LOOP ====================

  async main() {
    this.log('INFO', 'Autonomous Operator starting...');
    this.selectEmailBackend();
    await this.ensureLocalLLM();
    if (this.config.enableDashboard) this.startDashboard();

    // Main loop
    while (this.running) {
      try {
        // Run periodic tasks
        const now = new Date();
        if (now.getMinutes() % 30 === 0) { // every 30 minutes
          await this.runFollowupCycle();
        }
        await this.runDailyReport();
        // Update next-moves.md with latest status
        this.updateNextMoves();
      } catch (e) {
        this.log('ERROR', `Main loop error: ${e.message}`);
      }
      // Sleep 60 seconds
      await new Promise(resolve => setTimeout(resolve, 60000));
    }
  }

  updateNextMoves() {
    try {
      const nextMovesPath = path.join(process.env.WORKSPACE || process.cwd(), 'research/next-moves.md');
      if (fs.existsSync(nextMovesPath)) {
        let content = fs.readFileSync(nextMovesPath, 'utf8');
        const status = `\n\n[${new Date().toISOString()}] Autonomous Status: Email backend=${this.emailBackend}, Local LLM=${this.ollamaInstalled ? 'ready' : 'unavailable'}, Revenue pipeline: ${this.state.revenue.emailsSent} emails sent, ${this.state.revenue.replies} replies.\n`;
        // Prepend status note near top
        if (!content.includes('[AUTONOMOUS]')) {
          content = content.replace(/^## /, '## [AUTONOMOUS] Active — ' + this.emailBackend + '\n\n' + status + '\n## ');
          fs.writeFileSync(nextMovesPath, content);
        }
      }
    } catch (e) {
      // Don't fail the loop over this
    }
  }
}

// Entry point with CLI commands
if (require.main === module) {
  const op = new AutonomousOperator();
  const cmd = process.argv[2] || 'start';
  (async () => {
    switch (cmd) {
      case 'start':
        await op.main();
        break;
      case 'email-test':
        const backend = op.selectEmailBackend();
        console.log(`Selected email backend: ${backend}`);
        if (backend !== 'draft') {
          const result = await op.sendEmail(
            process.env.AUTONOMOUS_TEST_RECEIVER || 'iankmeeks@gmail.com',
            'Autonomous Operator Test',
            'This is a test email from your autonomous operator. Infrastructure is working.'
          );
          console.log('Send result:', result);
        } else {
          console.log('No functional email backend available; set up SMTP or gog OAuth.');
        }
        break;
      case 'status':
        console.log(JSON.stringify(op.generateReport(), null, 2));
        break;
      case 'version':
        console.log('Autonomous Operator v0.1.0');
        break;
      default:
        console.log('Unknown command. Available: start, email-test, status, version');
    }
  })().catch(e => {
    console.error('Fatal:', e);
    process.exit(1);
  });
}

module.exports = AutonomousOperator;

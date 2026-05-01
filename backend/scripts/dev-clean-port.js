import { execSync, spawn } from 'node:child_process';

function getPort() {
  const raw = process.env.PORT;
  const parsed = Number(raw);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : 3000;
}

function getListeningPidsWindows(port) {
  try {
    const output = execSync('netstat -ano -p tcp', {
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'ignore']
    });

    const lines = output.split(/\r?\n/);
    const pids = new Set();

    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed.startsWith('TCP')) {
        continue;
      }

      const parts = trimmed.split(/\s+/);
      if (parts.length < 5) {
        continue;
      }

      const localAddress = parts[1];
      const state = parts[3];
      const pid = parts[4];

      if (state !== 'LISTENING') {
        continue;
      }

      if (localAddress.endsWith(`:${port}`)) {
        pids.add(pid);
      }
    }

    return Array.from(pids);
  } catch {
    return [];
  }
}

function killPidWindows(pid) {
  try {
    execSync(`taskkill /PID ${pid} /F`, { stdio: 'ignore' });
    console.log(`[dev:clean] Stopped process PID ${pid} on port.`);
  } catch {
    console.log(`[dev:clean] Failed to stop PID ${pid} (may already be closed).`);
  }
}

function cleanupPort(port) {
  if (process.platform !== 'win32') {
    console.log('[dev:clean] Auto port cleanup is configured for Windows only.');
    return;
  }

  const pids = getListeningPidsWindows(port);

  if (pids.length === 0) {
    console.log(`[dev:clean] Port ${port} is free.`);
    return;
  }

  for (const pid of pids) {
    killPidWindows(pid);
  }
}

function startDevServer() {
  const child = spawn(process.execPath, ['--watch', 'src/server.js'], {
    stdio: 'inherit',
    env: process.env
  });

  child.on('exit', (code, signal) => {
    if (signal) {
      process.kill(process.pid, signal);
      return;
    }

    process.exit(code ?? 0);
  });

  process.on('SIGINT', () => child.kill('SIGINT'));
  process.on('SIGTERM', () => child.kill('SIGTERM'));
}

const port = getPort();
cleanupPort(port);
startDevServer();

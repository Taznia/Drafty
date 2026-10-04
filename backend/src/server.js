import { app } from './app.js';
import { connectDatabase, disconnectDatabase } from './config/database.js';
import { env } from './config/env.js';

const server = app.listen(env.PORT, () => {
  console.log(`CV Maker API listening on port ${env.PORT}`);
});

try {
  await connectDatabase();
} catch (error) {
  console.error('MongoDB connection failed:', error.message);
  await new Promise((resolve) => server.close(resolve));
  process.exitCode = 1;
}

async function shutdown(signal) {
  console.log(`${signal} received. Shutting down gracefully.`);
  await new Promise((resolve, reject) => server.close((error) => (error ? reject(error) : resolve())));
  await disconnectDatabase();
  process.exit(0);
}

process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));

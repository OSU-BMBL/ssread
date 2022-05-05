module.exports = {
  apps: [
    {
      name: 'scREAD frontend',
      script: './node_modules/nuxt-start/bin/nuxt-start.js',
      port: 9002,
      watch: '.',
      args: 'start -H 0.0.0.0',
      max_memory_restart: '5G',
      log_date_format: 'YYYY-MM=DD HH:mm:ss',
      env: {
        NODE_ENV: 'production'
      }
    }
  ]
}

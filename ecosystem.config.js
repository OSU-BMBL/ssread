module.exports = {
  apps: [
    {
      name: 'Scread database',
      script: './node_modules/nuxt-start/bin/nuxt-start.js',
      port: 9003,
      watch: '.',
      args: 'start -H 0.0.0.0',
      max_memory_restart: '5G',
      log_date_format: 'YYYY-MM=DD HH:mm:ss',
      env: {
        NODE_ENV: 'production',
      },
    },
  ],

  deploy: {
    production: {
      user: 'SSH_USERNAME',
      host: 'SSH_HOSTMACHINE',
      ref: 'origin/master',
      repo: 'GIT_REPOSITORY',
      path: 'DESTINATION_PATH',
      'pre-deploy-local': '',
      'post-deploy':
        'npm install && pm2 reload ecosystem.config.js --env production',
      'pre-setup': '',
    },
  },
}

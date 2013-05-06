exports.config =
  # See http://brunch.readthedocs.org/en/latest/config.html for documentation.
  paths:
    public: 'public'
  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/

    stylesheets:
      joinTo:
        'stylesheets/app.css': /^(app)/

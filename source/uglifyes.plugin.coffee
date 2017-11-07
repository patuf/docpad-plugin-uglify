# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class UglifyesPlugin extends BasePlugin
		# Plugin Name
		name: 'uglifyes'

		# Plugin Configuration
		config:
			# Disable on the development environment.
			environments:
				development:
					enabled: false

		# Constructor
		constructor: ->
			# Prepare
			super

			# Load UglifyES
			@UglifyES = require 'uglify-es'

			# Chain
			@

		# Render the document
		renderDocument: (opts,next) ->
			# Prepare.
			config = @getConfig()
			{extension, file, content} = opts
			uglifyOpts = file.get('uglify')

			# Ensure we are acting on a JavaScript document.
			if extension == 'js' and file.type == 'document' and uglifyOpts and config.enabled
				# Construct the options.
				uglifyOpts = {}  if typeof uglifyOpts == 'boolean'
				# uglifyOpts.fromString = true
				# @todo Use uglifyOpts.output to display warnings and logs.

				# Inject the default configuration options.
				for own key, value of config when key not in ['environments', 'enabled']
					uglifyOpts[key] ?= value

				# Minify the content with UglifyES.
				try
					result = @UglifyES.minify(content, uglifyOpts)
					opts.content = result.code
				catch err
					return next(err)

			# Done, return back to DocPad
			return next()

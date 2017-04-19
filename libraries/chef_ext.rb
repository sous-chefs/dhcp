# Hotfix Chef with bugfix for https://github.com/chef/chef/issues/2513
# if Gem::Version.new(Chef::VERSION) <= Gem::Version.new('12.4.1') # Once we know when it's officially released we will pin hotfix
class Chef
  module Mixin
    module Template
      class TemplateContext < Erubis::Context
        def render(partial_name, options = {})
          fail 'You cannot render partials in this context' unless @template_finder # rubocop:disable SignalException

          partial_variables = options.delete(:variables) || _public_instance_variables
          partial_variables[:template_finder] = @template_finder
          partial_context = self.class.new(partial_variables)
          partial_context._extend_modules(@_extension_modules)

          template_location = @template_finder.find(partial_name, options)
          _render_template(IO.binread(template_location), partial_context)
        end
      end
    end
  end
end
# end

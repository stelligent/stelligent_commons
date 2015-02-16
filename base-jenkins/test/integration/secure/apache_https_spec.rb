require 'spec_helper'

apache_modules_to_be_enabled = %w{ssl rewrite}
apache_modules_to_be_enabled.each do |apache_module_to_be_enabled|
  describe apache_module(apache_module_to_be_enabled) do
    it { should be_installed_to_apache }
  end
end

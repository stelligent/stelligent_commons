#Copyright (c) 2014 Stelligent Systems LLC
#
#MIT LICENSE
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

node['jenkins']['global_vars'].each do |key, value|
  magic_shell_environment "#{key}" do
    value "#{value}"
  end
end

jenkins_sysconfig_file = '/etc/sysconfig/jenkins'

directory ::File.dirname(jenkins_sysconfig_file) do
  action :create
  mode 0644
  recursive true
end

file jenkins_sysconfig_file do
  action :create
  mode 0644
end

# jenkins does not run in a login shell, so we need to force it to load the profile.d entries, which is where magic shell does its magic.
ruby_block 'setup profile.d for jenkins user' do
  block do
    line = 'source /etc/profile'
    file = Chef::Util::FileEdit.new('/etc/sysconfig/jenkins')
    file.insert_line_if_no_match(/#{line}/, line)
    file.write_file
  end
end
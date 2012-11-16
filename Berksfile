# -*- mode: ruby -*-
# vi: set ft=ruby :
#
#
site :opscode
metadata

cookbook "yum", github: "opscode-cookbooks/yum"
group "dev" do
  cookbook "helpers-databags", github: "spheromak/helpers-databags-cookbook", branch: "develop"
end

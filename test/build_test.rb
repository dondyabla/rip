require 'helper'

class BuildTest < Rip::Test
  test "build returns original path if the package has no extensions" do
    out = rip "package-git git://localhost/cijoe"
    assert_exited_successfully out
    path = out.chomp

    out = rip "build #{path}"
    assert_equal path, out.chomp
  end

  test "build extconf" do
    out = rip "package-git git://localhost/yajl-ruby"
    assert_exited_successfully out
    path = out.chomp

    out = rip "build #{path}"
    target = "#{@ripdir}/.packages/yajl-ruby-#{Rip.md5("afaf2451eb6ee54b2eebba1910ab0cbb#{Rip.ruby}")}"
    assert_equal target, out.chomp

    assert File.exist?("#{target}/ext/Makefile")
    assert Dir["#{target}/ext/yajl_ext.*"].any?

    assert File.exist?("#{target}/lib/yajl.rb")
    assert Dir["#{target}/lib/yajl_ext.*"].any?
  end

  test "writes build.rip" do
    out = rip "package-git git://localhost/yajl-ruby"
    assert_exited_successfully out

    path = out.chomp
    target = rip("build #{path}").chomp

    assert File.exist?("#{target}/build.rip")
    assert_equal Rip.ruby, File.read("#{target}/build.rip").chomp
  end
end

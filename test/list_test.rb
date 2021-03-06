require 'helper'

class ListTest < Rip::Test
  def setup
    super
    rip "install git://localhost/cijoe"
  end

  test "lists installed packages" do
    assert_equal <<installed, rip("list")
ripenv: base

choice (8b12556493)
cijoe (0441988287)
rack (1.0)
sinatra (0.9.4)
tinder (1.2.0)
installed
  end

  test "rip-list-minimal" do
    assert_equal <<installed, rip("list-minimal")
git://localhost/cijoe 04419882877337e70ac572a36d25416b0da9ba0f
installed
  end

  test "is ripenv specific" do
    rip "env -c newguy"
    rip "env newguy"

    rip "install git://localhost/rack"
    assert_equal <<installed, rip("list")
ripenv: newguy

rack (01532da684)
installed
  end
end

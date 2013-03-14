maintainer       "Skystack Limited"
maintainer_email "team@skystack.com"
license          "Apache 2.0"
description      "Skystack Remote Client affectionately known as Outpost, a cheap and stable way to collect useful data from your server and send it back to base."
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"
recipe           "outpost::default", "Install and starts Outpost"
%w{ erlang }.each do |cb|
  depends cb
end

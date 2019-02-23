#!/bin/bash
#Description: Example notifications for notification-daemon
#May work with notify-osd, not tested.

notify-send \
-i gtk-help \
-t 5000 \
"Main Title" \
'Normal text \
<a href="http://example.com/relnote">link</a> \
<b>Bold text</b> \
<i>Italic text</i>
<small>small text</small>
<big>big text</big>
<sub> sub text</sub> you see? <sup> sup text </sup>
<u> undernlined text </u>
<tt> monospace text </tt>
<s> strikethrough text </s>
<span background=\"#007f00\" font_desc=\"Ubuntu Italic 24\" foreground=\"#ff7f7f\" stretch=\"ultraexpanded\" strikethrough=\"true\" underline=\"double\" variant=\"smallcaps\" weight=\"900\">Span Text</span>'

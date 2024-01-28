# https://github.com/rss2email/rss2email/tree/master/rss2email/post_process
# this post-processing scripts prepends "[rss2email] $FEED_NAME: " to the subject of emails sent by rss2email
import rss2email.email

def prepend_title_to_subject(feed, message):
    initial_subject = message['Subject']
    del message['Subject']
    message['Subject'] = '[rss2email] {}: {}'.format(feed.name, initial_subject)
    return message

def process(feed, parsed, entry, guid, message):
    message = prepend_title_to_subject(feed, message)
    return message

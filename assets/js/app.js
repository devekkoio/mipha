import 'phoenix_html'
import 'bootstrap'

// JS components
import Times from './app/components/times'
import Utils from './app/components/utils'
import Topic from './app/components/topic'

// Decorate
Times.humanize()
Utils.navActive()
// Topic
Topic.selectorNode()
Topic.hookPreview($('.editor-toolbar'), $('.topic-editor'))
Topic.hookReply()

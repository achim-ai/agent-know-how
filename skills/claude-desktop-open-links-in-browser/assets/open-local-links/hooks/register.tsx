import type { Register } from 'claude-code'

const FILE_LINK = /\]\((file:\/\/[^)\s]+)\)/g

const hash = (text: string) => {
  let value = 0
  for (let index = 0; index < text.length; index++) value = (value * 31 + text.charCodeAt(index)) | 0
  return (value >>> 0).toString(36)
}

const toPath = (href: string) => decodeURIComponent(href.replace(/^file:\/\/(localhost)?/, ''))

export const register: Register = on => {
  on('ui.render', { component: 'AssistantMessage' }, ($, e, next) => {
    const links = [...e.props.text.matchAll(FILE_LINK)].map(match => match[1])
    if (links.length === 0) return next(e)
    const { Markdown } = $.ui.resolve(e)
    return (
      <Markdown
        key={`local-links-${hash(e.props.text)}`}
        text={e.props.text}
        pressableLinks={links}
        onLinkPress={link => {
          void $.process.run(['/usr/bin/open', toPath(link.href)])
        }}
      />
    )
  })
}

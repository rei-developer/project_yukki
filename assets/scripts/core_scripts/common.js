// const debug = text => _call('debug', _json({ text }))

const _json = args => JSON.stringify(args)

const _call = (channelName, args) => sendMessage(channelName, args)

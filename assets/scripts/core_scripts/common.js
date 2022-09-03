const alert = (description, options = {}) => _call('alert', _json({ title: options?.title, description }))

const _json = args => JSON.stringify(args)

const _call = (channelName, args) => sendMessage(channelName, args)

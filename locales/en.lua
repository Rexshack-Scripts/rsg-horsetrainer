local Translations = {
    error = {
		--var = 'text goes here',
    },
    success = {
		xp_now = 'horse xp now',
    },
    info = {
		--var = 'text goes here',
    },
    menu = {
		--var = 'text goes here',
    },
    commands = {
		--var = 'text goes here',
    },
    progressbar = {
		--var = 'text goes here',
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

-- Lang:t('success.xp_now')
local Translations = {
    error = {
		horse_brush_needed = 'horse trainer brush needed for this',
		not_horse_trainer = 'you are not a horse trainer!',
		horse_too_clean = 'horse is too clean right now!',
		carrot_needed = 'carrot needed for this',
		horse_too_full = 'horse is too full right now!',
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

-- Lang:t('error.horse_too_full')
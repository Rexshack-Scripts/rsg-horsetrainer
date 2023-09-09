local Translations = {
error = {
    horse_brush_needed = 'É necessário um pincel de treinador de cavalos!',
    not_horse_trainer = 'Você não é um treinador de cavalos!',
    horse_too_clean = 'O cavalo está muito limpo agora!',
    carrot_needed = 'É necessário uma cenoura para alimentar o cavalo!',
    horse_too_full = 'O cavalo está muito cheio agora!',
    horse_too_far = 'Por favor, se aproxime mais do seu cavalo!'
},
success = {
    xp_now = ' EXP agora é ',
},
info = {
    --var = 'o texto vai aqui',
},
menu = {
    --var = 'o texto vai aqui',
},
commands = {
    --var = 'o texto vai aqui',
},
progressbar = {
    --var = 'o texto vai aqui',
},

}

if GetConvar('rsg_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end

-- Lang:t('error.horse_too_full')

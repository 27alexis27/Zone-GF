GFConfig = {
    Framework = "es_extended", -- nom du framework
    Commandleave = 'leavegf', -- commande pour quitter la zonz gf
    invicible = 5000, -- temps que la personne sera invincible a chaques reanimation
    Ammocount = 15, -- munition ajouter a chaque fois (chargeur infini dinc je ne conseille pas de changer)
 
    posrea = { -- position lorrsque la personne va se reanimer
    vector4(2401.944, 3140.68, 48.15358, 223.5514),
    vector4(2408.192, 3033.545, 48.15258, 3.203589),
    vector4(2340.272, 3052.285, 48.15099, 268.9685),
    vector4(2348.966, 3133.121, 48.20879, 261.6647),
    },

    posbp = vector3(-292.4788, -919.951, 30.08061),
    Typemarker = 1,
    namebp = "~y~[activité]~s~ Zone gunfight",  -- nom du blips
    scbp = 0.8, -- taille du blips
    idbp = 303, -- type de blips (id du blips)
    colorbp = 1, -- couleur du blips
    coordsgf = vector3(2389.616, 3094.874, 48.1524),
    echelle = vector3(92.0, 92.0, 92.0) -- taille de la zone gf
}
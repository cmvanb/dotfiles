#-------------------------------------------------------------------------------
# Mako notification daemon configuration
#-------------------------------------------------------------------------------

# Behavior
#-------------------------------------------------------------------------------

# NOTE: Mako crashes if max-visible is too large and too many notifications are
# spawned.
max-visible=15

sort=+time

default-timeout=4000

# Enable pango formatted notification.
markup=1

# Applications may request an action.
actions=1

# Bindings
#-------------------------------------------------------------------------------

on-button-left=invoke-default-action
on-button-middle=dismiss-group
on-button-right=dismiss
on-touch=invoke-default-action

# Appearance
#-------------------------------------------------------------------------------

# Render on top of full-screen windows.
layer=overlay

anchor=bottom-right

text-alignment=left
icon-location=left

width=500
height=250
margin=16,16
outer-margin=16,0
# top,right,bottom,left
padding=10,8

font=${font_sans} ${font_size_medium}

background-color=${color_hash('primary_1', 1.0)}
text-color=${color_hash('system_text', 1.0)}

border-size=3
border-color=${color_hash('primary_8', 1.0)}
border-radius=0

@ ----------- EXTERN FUNCTIONS FROM C ----------------
.extern Music_Load
.extern Music_Play
.extern Music_Unload
.extern Texture_Create_Bitmap
.extern Texture_Load
.extern Texture_Draw
.extern Texture_Unload
.extern F1Race_Render_Score
.extern F1Race_Show_Game_Over_Screen
.extern F1Race_Render_Separator
.extern F1Race_Render_Road
.extern F1Race_Render_Score
.extern F1Race_Render_Status
.extern F1Race_Render_Player_Car
.extern F1Race_Render_Opposite_Car
.extern F1Race_Render_Player_Car_Crash
.extern F1Race_Render 
.extern F1Race_Render_Background
.extern F1Race_Init
.extern F1Race_Main
.extern F1Race_Key_Pressed
.extern F1Race_Key_Left_Released
.extern F1Race_Key_Right_Pressed
.extern F1Race_Key_Right_Released
.extern F1Race_Key_Up_Pressed
.extern F1Race_Key_Up_Released
.extern F1Race_Key_Down_Pressed
.extern F1Race_Key_Down_Released
.extern F1Race_Key_Fly_Pressed
.extern F1Race_Keyboard_Key_Handler

@ ----------- UI CODE (INITIALIZATION) ----------------
	.text
	.local	music_tracks
	.comm	music_tracks,16,4
	.data
	.align	2
	.type	volume_old, %object
	.size	volume_old, 4
volume_old:
	.word	-1
	.local	textures
	.comm	textures,128,4
	.local	exit_main_loop
	.comm	exit_main_loop,4,4
	.local	using_new_background_ogg
	.comm	using_new_background_ogg,4,4
	.local	render
	.comm	render,4,4
	.type	f1race_is_new_game, %object
	.size	f1race_is_new_game, 4
@ variables for the new game
f1race_is_new_game:
	.word	1
	.local	f1race_is_crashing
	.comm	f1race_is_crashing,4,4
	.local	f1race_crashing_count_down
	.comm	f1race_crashing_count_down,2,2
	.local	f1race_separator_0_block_start_y
	.comm	f1race_separator_0_block_start_y,2,2
	.local	f1race_separator_1_block_start_y
	.comm	f1race_separator_1_block_start_y,2,2
	.local	f1race_last_car_road
	.comm	f1race_last_car_road,2,2
	.local	f1race_player_is_car_fly
	.comm	f1race_player_is_car_fly,4,4
	.local	f1race_player_car_fly_duration
	.comm	f1race_player_car_fly_duration,2,2
	.local	f1race_score
	.comm	f1race_score,2,2
	.local	f1race_level
	.comm	f1race_level,2,2
	.local	f1race_pass
	.comm	f1race_pass,2,2
	.local	f1race_fly_count
	.comm	f1race_fly_count,2,2
	.local	f1race_fly_charger_count
	.comm	f1race_fly_charger_count,2,2
	.local	f1race_key_up_pressed
	.comm	f1race_key_up_pressed,4,4
	.local	f1race_key_down_pressed
	.comm	f1race_key_down_pressed,4,4
	.local	f1race_key_right_pressed
	.comm	f1race_key_right_pressed,4,4
	.local	f1race_key_pressed
	.comm	f1race_key_pressed,4,4
	.local	f1race_player_car
	.comm	f1race_player_car,20,4
	.local	f1race_opposite_car_type
	.comm	f1race_opposite_car_type,84,4
	.local	f1race_opposite_car
	.comm	f1race_opposite_car,224,4
	.section	.rodata
	.align	2
.Sound1: @ background music
	.ascii	"assets/GAME_F1RACE_BGM.ogg\000"
	.align	2
.Sound2: @ background music
	.ascii	"assets/GAME_F1RACE_BGM1.ogg\000"
	.align	2
.Sound3: @ car crash sound
	.ascii	"assets/GAME_F1RACE_CRASH.ogg\000"
	.align	2
.Sound4: @ gameover music
	.ascii	"assets/GAME_F1RACE_GAMEOVER.ogg\000"
	.text
	.align	2
	.arch armv6
	.type	Music_Load, %function
@loads a series of music tracks using the "Mix_LoadMUS" function
Music_Load:
	push	{fp, lr}
	add	fp, sp, #4
	ldr	r0, .LoadMusicTrack
	bl	Mix_LoadMUS
	mov	r3, r0
	ldr	r2, .LoadMusicTrack+4
	str	r3, [r2]
	ldr	r0, .LoadMusicTrack+8
	bl	Mix_LoadMUS
	mov	r3, r0
	ldr	r2, .LoadMusicTrack+4
	str	r3, [r2, #4]
	ldr	r0, .LoadMusicTrack+12
	bl	Mix_LoadMUS
	mov	r3, r0
	ldr	r2, .LoadMusicTrack+4
	str	r3, [r2, #8]
	ldr	r0, .LoadMusicTrack+16
	bl	Mix_LoadMUS
	mov	r3, r0
	ldr	r2, .LoadMusicTrack+4
	str	r3, [r2, #12]
	pop	{fp, pc}
	
@defining a data structure
.LoadMusicTrack:
	.word	.Sound1
	.word	music_tracks
	.word	.Sound2
	.word	.Sound3
	.word	.Sound4
	.size	Music_Load, .-Music_Load
	.align	2
	.type	Music_Play, %function

@ plays a specific music track using the "Mix_PlayMusic" function
Music_Play:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	str	r0, [fp, #-8]
	str	r1, [fp, #-12]
	ldr	r2, .MusicSetTrack
	ldr	r3, [fp, #-8]
	ldr	r3, [r2, r3, lsl #2]
	ldr	r1, [fp, #-12]
	mov	r0, r3
	bl	Mix_PlayMusic
	sub	sp, fp, #4
	pop	{fp, pc}
@ defining data or attributes of music
.MusicSetTrack:
	.word	music_tracks
	.size	Music_Play, .-Music_Play
	.align	2
	.type	Music_Unload, %function
	
@ sets up a stack frame, initializes a counter or flag to 0, and then branches to ".CheckMusicCount."
Music_Unload:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.CheckMusicCount
@ checking and freeing a music track if it's not null
.FreeMusicIfNotNull:
	ldr	r2, .MusicTracksArray
	ldr	r3, [fp, #-8]
	ldr	r3, [r2, r3, lsl #2]
	cmp	r3, #0
	beq	.IncrementCounter
	ldr	r2, .MusicTracksArray
	ldr	r3, [fp, #-8]
	ldr	r3, [r2, r3, lsl #2]
	mov	r0, r3
	bl	Mix_FreeMusic
@ increments counter by 1
.IncrementCounter:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
@ check for loaded music
.CheckMusicCount:
	ldr	r3, [fp, #-8]
	cmp	r3, #3
	ble	.FreeMusicIfNotNull
	sub	sp, fp, #4
	pop	{fp, pc}
@ array for music tracks
.MusicTracksArray:
	.word	music_tracks
	.size	Music_Unload, .-Music_Unload
	.section	.rodata
	.align	2
.TextureCreateBitmap:
	.ascii	"rb\000"
	.text
	.align	2
	.type	Texture_Create_Bitmap, %function
@ creating a bitmap texture from a BMP image using SDL. 
Texture_Create_Bitmap:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	ldr	r1, .TextureCreateBitmapSection
	ldr	r0, [fp, #-16]
	bl	SDL_RWFromFile
	mov	r3, r0
	mov	r1, #1
	mov	r0, r3
	bl	SDL_LoadBMP_RW
	str	r0, [fp, #-8]
	ldr	r3, .TextureCreateBitmapSection+4
	ldr	r3, [r3]
	ldr	r1, [fp, #-8]
	mov	r0, r3
	bl	SDL_CreateTextureFromSurface
	mov	r2, r0
	ldr	r1, .TextureCreateBitmapSection+8
	ldr	r3, [fp, #-20]
	str	r2, [r1, r3, lsl #2]
	ldr	r0, [fp, #-8]
	bl	SDL_FreeSurface
	sub	sp, fp, #4
	pop	{fp, pc}
	
@ Store TextureBitmapdata
.TextureCreateBitmapSection:
	.word	.TextureCreateBitmap
	.word	render
	.word	textures
	.size	Texture_Create_Bitmap, .-Texture_Create_Bitmap
	.section	.rodata
	.align	2

@ image from asset
.F1Race_Number_0_Texture: @ number0 (used for score)
	.ascii	"assets/GAME_F1RACE_NUMBER_0.bmp\000"
	.align	2
.F1Race_Number_1_Texture: @ number1 (used for score)
	.ascii	"assets/GAME_F1RACE_NUMBER_1.bmp\000"
	.align	2
.F1Race_Number_2_Texture: @ number2 (used for score)
	.ascii	"assets/GAME_F1RACE_NUMBER_2.bmp\000"
	.align	2
.F1Race_Number_3_Texture: @ number3 (used for score)
	.ascii	"assets/GAME_F1RACE_NUMBER_3.bmp\000"
	.align	2
.F1Race_Number_4_Texture: @ number4 (used for score)
	.ascii	"assets/GAME_F1RACE_NUMBER_4.bmp\000"
	.align	2
.F1Race_Number_5_Texture: @ number5 (used for score)
	.ascii	"assets/GAME_F1RACE_NUMBER_5.bmp\000"
	.align	2
.F1Race_Number_6_Texture: @ number6 (used for score)
	.ascii	"assets/GAME_F1RACE_NUMBER_6.bmp\000"
	.align	2
.F1Race_Number_7_Texture: @ number7 (used for score)
	.ascii	"assets/GAME_F1RACE_NUMBER_7.bmp\000"
	.align	2
.F1Race_Number_8_Texture: @ number8 (used for score)
	.ascii	"assets/GAME_F1RACE_NUMBER_8.bmp\000"
	.align	2
.F1Race_Number_9_Texture: @ number9 (used for score)
	.ascii	"assets/GAME_F1RACE_NUMBER_9.bmp\000"
	.align	2
.F1Race_Player_Car_Texture: @ player's car texture
	.ascii	"assets/GAME_F1RACE_PLAYER_CAR.bmp\000"
	.align	2
.F1Race_Player_Car_Fly_Texture: @ player's car fly texture
	.ascii	"assets/GAME_F1RACE_PLAYER_CAR_FLY.bmp\000"
	.align	2
.F1Race_Player_Car_Fly_Up_Texture: @ player's car fly up texture
	.ascii	"assets/GAME_F1RACE_PLAYER_CAR_FLY_UP.bmp\000"
	.align	2
.F1Race_Player_Car_Fly_Down_Texture: @ player's car fly down texture
	.ascii	"assets/GAME_F1RACE_PLAYER_CAR_FLY_DOWN.bmp\000"
	.align	2
.F1Race_Player_Car_Headlight_Texture: @ player's car headlight texture
	.ascii	"assets/GAME_F1RACE_PLAYER_CAR_HEAD_LIGHT.bmp\000"
	.align	2
.F1Race_Player_Car_Crash_Texture: @ player's car crash texture
	.ascii	"assets/GAME_F1RACE_PLAYER_CAR_CRASH.bmp\000"
	.align	2
.F1Race_Logo_Texture: @ game logo on the top right
	.ascii	"assets/GAME_F1RACE_LOGO.bmp\000"
	.align	2
.F1Race_Status_Score_Texture: @ score texture
	.ascii	"assets/GAME_F1RACE_STATUS_SCORE.bmp\000"
	.align	2
.F1Race_Status_Box_Texture: @ score box texture
	.ascii	"assets/GAME_F1RACE_STATUS_BOX.bmp\000"
	.align	2
.F1Race_Status_Level_Texture: @ level texture
	.ascii	"assets/GAME_F1RACE_STATUS_LEVEL.bmp\000"
	.align	2
.F1Race_Status_Fly_Texture: @ fly texture
	.ascii	"assets/GAME_F1RACE_STATUS_FLY.bmp\000"
	.align	2
.F1Race_Opposite_Car_0: @ opponent car texture0
	.ascii	"assets/GAME_F1RACE_OPPOSITE_CAR_0.bmp\000"
	.align	2
.F1Race_Opposite_Car_1: @ opponent car texture1
	.ascii	"assets/GAME_F1RACE_OPPOSITE_CAR_1.bmp\000"
	.align	2
.F1Race_Opposite_Car_2: @ opponent car texture2
	.ascii	"assets/GAME_F1RACE_OPPOSITE_CAR_2.bmp\000"
	.align	2
.F1Race_Opposite_Car_3: @ opponent car texture3
	.ascii	"assets/GAME_F1RACE_OPPOSITE_CAR_3.bmp\000"
	.align	2
.F1Race_Opposite_Car_4: @ opponent car texture4
	.ascii	"assets/GAME_F1RACE_OPPOSITE_CAR_4.bmp\000"
	.align	2
.F1Race_Opposite_Car_5: @ opponent car texture5
	.ascii	"assets/GAME_F1RACE_OPPOSITE_CAR_5.bmp\000"
	.align	2
.F1Race_Opposite_Car_6: @ opponent car texture6
	.ascii	"assets/GAME_F1RACE_OPPOSITE_CAR_6.bmp\000"
	.align	2
.F1Race_GameOver: @ gameover screen
	.ascii	"assets/GAME_F1RACE_GAMEOVER.bmp\000"
	.align	2
.F1Race_GameOverCrash: @ gameover image
	.ascii	"assets/GAME_F1RACE_GAMEOVER_CRASH.bmp\000"
	.align	2
.F1Race_GameOverField: @ gameover field texture
	.ascii	"assets/GAME_F1RACE_GAMEOVER_FIELD.bmp\000"
	.text
	.align	2
	.type	Texture_Load, %function
	
@ load textures
Texture_Load:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	ldr	r3, .TextureLoader
	ldr	r0, [r3]
	mov	r3, #128
	str	r3, [sp]
	mov	r3, #128
	mov	r2, #2
	ldr	r1, .TextureLoader+4
	bl	SDL_CreateTexture
	mov	r3, r0
	ldr	r2, .TextureLoader+8
	str	r3, [r2, #40]
	mov	r1, #0
	ldr	r0, .TextureLoader+12
	bl	Texture_Create_Bitmap
	mov	r1, #1
	ldr	r0, .TextureLoader+16
	bl	Texture_Create_Bitmap
	mov	r1, #2
	ldr	r0, .TextureLoader+20
	bl	Texture_Create_Bitmap
	mov	r1, #3
	ldr	r0, .TextureLoader+24
	bl	Texture_Create_Bitmap
	mov	r1, #4
	ldr	r0, .TextureLoader+28
	bl	Texture_Create_Bitmap
	mov	r1, #5
	ldr	r0, .TextureLoader+32
	bl	Texture_Create_Bitmap
	mov	r1, #6
	ldr	r0, .TextureLoader+36
	bl	Texture_Create_Bitmap
	mov	r1, #7
	ldr	r0, .TextureLoader+40
	bl	Texture_Create_Bitmap
	mov	r1, #8
	ldr	r0, .TextureLoader+44
	bl	Texture_Create_Bitmap
	mov	r1, #9
	ldr	r0, .TextureLoader+48
	bl	Texture_Create_Bitmap
	mov	r1, #11
	ldr	r0, .TextureLoader+52
	bl	Texture_Create_Bitmap
	mov	r1, #12
	ldr	r0, .TextureLoader+56
	bl	Texture_Create_Bitmap
	mov	r1, #13
	ldr	r0, .TextureLoader+60
	bl	Texture_Create_Bitmap
	mov	r1, #14
	ldr	r0, .TextureLoader+64
	bl	Texture_Create_Bitmap
	mov	r1, #15
	ldr	r0, .TextureLoader+68
	bl	Texture_Create_Bitmap
	mov	r1, #16
	ldr	r0, .TextureLoader+72
	bl	Texture_Create_Bitmap
	mov	r1, #17
	ldr	r0, .TextureLoader+76
	bl	Texture_Create_Bitmap
	mov	r1, #18
	ldr	r0, .TextureLoader+80
	bl	Texture_Create_Bitmap
	mov	r1, #19
	ldr	r0, .TextureLoader+84
	bl	Texture_Create_Bitmap
	mov	r1, #20
	ldr	r0, .TextureLoader+88
	bl	Texture_Create_Bitmap
	mov	r1, #21
	ldr	r0, .TextureLoader+92
	bl	Texture_Create_Bitmap
	mov	r1, #22
	ldr	r0, .TextureLoader+96
	bl	Texture_Create_Bitmap
	mov	r1, #23
	ldr	r0, .TextureLoader+100
	bl	Texture_Create_Bitmap
	mov	r1, #24
	ldr	r0, .TextureLoader+104
	bl	Texture_Create_Bitmap
	mov	r1, #25
	ldr	r0, .TextureLoader+108
	bl	Texture_Create_Bitmap
	mov	r1, #26
	ldr	r0, .TextureLoader+112
	bl	Texture_Create_Bitmap
	mov	r1, #27
	ldr	r0, .TextureLoader+116
	bl	Texture_Create_Bitmap
	mov	r1, #28
	ldr	r0, .TextureLoader+120
	bl	Texture_Create_Bitmap
	mov	r1, #29
	ldr	r0, .TextureLoader+124
	bl	Texture_Create_Bitmap
	mov	r1, #31
	ldr	r0, .TextureLoader+128
	bl	Texture_Create_Bitmap
	mov	r1, #30
	ldr	r0, .TextureLoader+132
	bl	Texture_Create_Bitmap
	sub	sp, fp, #4
	pop	{fp, pc}

@ define the structure for textures
.TextureLoader:
	.word	render
	.word	373694468
	.word	textures
	.word	.F1Race_Number_0_Texture
	.word	.F1Race_Number_1_Texture
	.word	.F1Race_Number_2_Texture
	.word	.F1Race_Number_3_Texture
	.word	.F1Race_Number_4_Texture
	.word	.F1Race_Number_5_Texture
	.word	.F1Race_Number_6_Texture
	.word	.F1Race_Number_7_Texture
	.word	.F1Race_Number_8_Texture
	.word	.F1Race_Number_9_Texture
	.word	.F1Race_Player_Car_Texture
	.word	.F1Race_Player_Car_Fly_Texture
	.word	.F1Race_Player_Car_Fly_Up_Texture
	.word	.F1Race_Player_Car_Fly_Down_Texture
	.word	.F1Race_Player_Car_Headlight_Texture
	.word	.F1Race_Player_Car_Crash_Texture
	.word	.F1Race_Logo_Texture
	.word	.F1Race_Status_Score_Texture
	.word	.F1Race_Status_Box_Texture
	.word	.F1Race_Status_Level_Texture
	.word	.F1Race_Status_Fly_Texture
	.word	.F1Race_Opposite_Car_0
	.word	.F1Race_Opposite_Car_1
	.word	.F1Race_Opposite_Car_2
	.word	.F1Race_Opposite_Car_3
	.word	.F1Race_Opposite_Car_4
	.word	.F1Race_Opposite_Car_5
	.word	.F1Race_Opposite_Car_6
	.word	.F1Race_GameOver
	.word	.F1Race_GameOverCrash
	.word	.F1Race_GameOverField
	.size	Texture_Load, .-Texture_Load
	.align	2
	.type	Texture_Draw, %function

@ render textures
Texture_Draw:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #40
	str	r0, [fp, #-24]
	str	r1, [fp, #-28]
	str	r2, [fp, #-32]
	ldr	r3, [fp, #-24]
	str	r3, [fp, #-20]
	ldr	r3, [fp, #-28]
	str	r3, [fp, #-16]
	ldr	r2, .TextureUnload2
	ldr	r3, [fp, #-32]
	ldr	r0, [r2, r3, lsl #2]
	sub	r3, fp, #20
	add	r2, r3, #8
	sub	r3, fp, #20
	add	r3, r3, #12
	str	r3, [sp]
	mov	r3, r2
	mov	r2, #0
	mov	r1, #0
	bl	SDL_QueryTexture
	ldr	r3, .TextureUnload2+4
	ldr	r0, [r3]
	ldr	r2, .TextureUnload2
	ldr	r3, [fp, #-32]
	ldr	r1, [r2, r3, lsl #2]
	sub	r3, fp, #20
	mov	r2, #0
	bl	SDL_RenderCopy
	sub	sp, fp, #4
	pop	{fp, pc}
	
@ call unload texture function
.TextureUnload2:
	.word	textures
	.word	render
	.size	Texture_Draw, .-Texture_Draw
	.align	2
	.type	Texture_Unload, %function
@ unload texture
Texture_Unload:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.F1Race_Separate
@ checks if a texture exists (not null) in an array and destroys it if it does
.DestroyTextureIfNotNull:
	ldr	r2, .DisplayGameOverScreen
	ldr	r3, [fp, #-8]
	ldr	r3, [r2, r3, lsl #2]
	cmp	r3, #0
	beq	.F1Race_UpdateSeparator
	ldr	r2, .DisplayGameOverScreen
	ldr	r3, [fp, #-8]
	ldr	r3, [r2, r3, lsl #2]
	mov	r0, r3
	bl	SDL_DestroyTexture
@ handles rendering road separators
.F1Race_UpdateSeparator:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
	
@ seperate road
.F1Race_Separate:
	ldr	r3, [fp, #-8]
	cmp	r3, #31
	ble	.DestroyTextureIfNotNull
	sub	sp, fp, #4
	pop	{fp, pc}

@ displaying game over screen
.DisplayGameOverScreen:
	.word	textures
	.size	Texture_Unload, .-Texture_Unload
	.align	2
	.type	F1Race_Show_Game_Over_Screen, %function

@ Rendering Game Over Screen
F1Race_Show_Game_Over_Screen:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	ldr	r3, .RenderDataReference
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #0
	mov	r2, #0
	mov	r1, #0
	bl	SDL_SetRenderDrawColor
	ldr	r3, .RenderDataReference
	ldr	r3, [r3]
	mov	r0, r3
	bl	SDL_RenderClear
	mov	r2, #29
	mov	r1, #10
	mov	r0, #18
	bl	Texture_Draw
	mov	r2, #30
	mov	r1, #40
	mov	r0, #30
	bl	Texture_Draw
	ldr	r3, .RenderDataReference
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #0
	mov	r2, #0
	mov	r1, #0
	bl	SDL_SetRenderDrawColor
	mov	r3, #33
	str	r3, [fp, #-20]
	mov	r3, #43
	str	r3, [fp, #-16]
	mov	r3, #64
	str	r3, [fp, #-12]
	mov	r3, #20
	str	r3, [fp, #-8]
	ldr	r3, .RenderDataReference
	ldr	r3, [r3]
	sub	r2, fp, #20
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderFillRect
	mov	r2, #18
	mov	r1, #50
	mov	r0, #36
	bl	Texture_Draw
	mov	r2, #19
	mov	r1, #48
	mov	r0, #65
	bl	Texture_Draw
	mvn	r1, #1
	mov	r0, #64
	bl	F1Race_Render_Score
	mov	r2, #31
	mov	r1, #80
	mov	r0, #47
	bl	Texture_Draw
	sub	sp, fp, #4
	pop	{fp, pc}

@ -----------------------render road separators and update position--------------------------
.RenderDataReference:
	.word	render
	.size	F1Race_Show_Game_Over_Screen, .-F1Race_Show_Game_Over_Screen
	.align	2
	.type	F1Race_Render_Separator, %function
F1Race_Render_Separator:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #32
	ldr	r3, .F1Race_Render_RoadSeparator
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #250
	mov	r2, #250
	mov	r1, #250
	bl	SDL_SetRenderDrawColor
	mov	r3, #33
	str	r3, [fp, #-24]
	mov	r3, #3
	str	r3, [fp, #-20]
	ldr	r3, [fp, #-24]
	rsb	r3, r3, #36
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-20]
	rsb	r3, r3, #124
	str	r3, [fp, #-12]
	ldr	r3, .F1Race_Render_RoadSeparator
	ldr	r3, [r3]
	sub	r2, fp, #24
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderFillRect
	ldr	r3, .F1Race_Render_RoadSeparator
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #250
	mov	r2, #250
	mov	r1, #250
	bl	SDL_SetRenderDrawColor
	mov	r3, #59
	str	r3, [fp, #-24]
	mov	r3, #3
	str	r3, [fp, #-20]
	ldr	r3, [fp, #-24]
	rsb	r3, r3, #62
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-20]
	rsb	r3, r3, #124
	str	r3, [fp, #-12]
	ldr	r3, .F1Race_Render_RoadSeparator
	ldr	r3, [r3]
	sub	r2, fp, #24
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderFillRect
	ldr	r3, .F1Race_Render_RoadSeparator+4
	ldrh	r3, [r3]	
	strh	r3, [fp, #-6]	
	ldrh	r3, [fp, #-6]
	add	r3, r3, #3
	strh	r3, [fp, #-8]	
.F1Race_RenderRoadSeparatorAndUpdatePosition:
	ldr	r3, .F1Race_Render_RoadSeparator
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #100
	mov	r2, #100
	mov	r1, #100
	bl	SDL_SetRenderDrawColor
	mov	r3, #33
	str	r3, [fp, #-24]
	ldrsh	r3, [fp, #-6]
	str	r3, [fp, #-20]
	ldr	r3, [fp, #-24]
	rsb	r3, r3, #36
	str	r3, [fp, #-16]
	ldrsh	r2, [fp, #-8]
	ldr	r3, [fp, #-20]
	sub	r3, r2, r3
	str	r3, [fp, #-12]
	ldr	r3, .F1Race_Render_RoadSeparator
	ldr	r3, [r3]
	sub	r2, fp, #24
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderFillRect
	ldrh	r3, [fp, #-6]
	add	r3, r3, #18
	strh	r3, [fp, #-6]	
	ldrh	r3, [fp, #-6]
	add	r3, r3, #3
	strh	r3, [fp, #-8]
	ldrsh	r3, [fp, #-6]
	cmp	r3, #124
	bgt	.F1Race_EndSeparatorPosition
	ldrsh	r3, [fp, #-8]
	cmp	r3, #124
	ble	.F1Race_RenderRoadSeparatorAndUpdatePosition
	mov	r3, #124
	strh	r3, [fp, #-8]
	b	.F1Race_RenderRoadSeparatorAndUpdatePosition
.F1Race_EndSeparatorPosition:
	ldr	r3, .F1Race_Render_RoadSeparator+4
	ldrsh	r3, [r3]
	add	r3, r3, #3
	sxth	r3, r3
	ldr	r2, .F1Race_Render_RoadSeparator+4
	strh	r3, [r2]
	ldr	r3, .F1Race_Render_RoadSeparator+4
	ldrsh	r3, [r3]
	cmp	r3, #20
	ble	.F1Race_UpdateSeparatorPosition
	ldr	r3, .F1Race_Render_RoadSeparator+4
	mov	r2, #3
	strh	r2, [r3]
.F1Race_UpdateSeparatorPosition:
	ldr	r3, .F1Race_Render_RoadSeparator+8
	ldrh	r3, [r3]
	strh	r3, [fp, #-6]
	ldrh	r3, [fp, #-6]
	add	r3, r3, #3
	strh	r3, [fp, #-8]
.F1Race_RenderSeparatorAndRoad:
	ldr	r3, .F1Race_Render_RoadSeparator
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #100
	mov	r2, #100
	mov	r1, #100
	bl	SDL_SetRenderDrawColor
	mov	r3, #59
	str	r3, [fp, #-24]
	ldrsh	r3, [fp, #-6]
	str	r3, [fp, #-20]
	ldr	r3, [fp, #-24]
	rsb	r3, r3, #62
	str	r3, [fp, #-16]
	ldrsh	r2, [fp, #-8]
	ldr	r3, [fp, #-20]
	sub	r3, r2, r3
	str	r3, [fp, #-12]
	ldr	r3, .F1Race_Render_RoadSeparator
	ldr	r3, [r3]
	sub	r2, fp, #24
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderFillRect
	ldrh	r3, [fp, #-6]
	add	r3, r3, #18
	strh	r3, [fp, #-6]	
	ldrh	r3, [fp, #-6]
	add	r3, r3, #3
	strh	r3, [fp, #-8]	
	ldrsh	r3, [fp, #-6]
	cmp	r3, #124
	bgt	.F1Race_AdjustSeparatorPosition
	ldrsh	r3, [fp, #-8]
	cmp	r3, #124
	ble	.F1Race_RenderSeparatorAndRoad
	mov	r3, #124
	strh	r3, [fp, #-8]	
	b	.F1Race_RenderSeparatorAndRoad
.F1Race_AdjustSeparatorPosition:
	ldr	r3, .F1Race_Render_RoadSeparator+8
	ldrsh	r3, [r3]
	add	r3, r3, #3
	sxth	r3, r3
	ldr	r2, .F1Race_Render_RoadSeparator+8
	strh	r3, [r2]	
	ldr	r3, .F1Race_Render_RoadSeparator+8
	ldrsh	r3, [r3]
	cmp	r3, #20
	ble	.F1Race_EndGameLoop
	ldr	r3, .F1Race_Render_RoadSeparator+8
	mov	r2, #3
	strh	r2, [r3]

@ end function for seperator
.F1Race_EndGameLoop:
	sub	sp, fp, #4
	pop	{fp, pc}

@ call seperator function
.F1Race_Render_RoadSeparator:
	.word	render
	.word	f1race_separator_0_block_start_y
	.word	f1race_separator_1_block_start_y
	.size	F1Race_Render_Separator, .-F1Race_Render_Separator
	.align	2
	.type	F1Race_Render_Road, %function

@ render the road
F1Race_Render_Road:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	ldr	r3, .F1Race_Render_RoadScore
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #100
	mov	r2, #100
	mov	r1, #100
	bl	SDL_SetRenderDrawColor
	mov	r3, #10
	str	r3, [fp, #-20]
	mov	r3, #3
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-20]
	rsb	r3, r3, #85
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-16]
	rsb	r3, r3, #124
	str	r3, [fp, #-8]
	ldr	r3, .F1Race_Render_RoadScore
	ldr	r3, [r3]
	sub	r2, fp, #20
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderFillRect
	sub	sp, fp, #4
	pop	{fp, pc}
	
@ call score render function
.F1Race_Render_RoadScore:
	.word	render
	.size	F1Race_Render_Road, .-F1Race_Render_Road
	.align	2
	.type	F1Race_Render_Score, %function

@ render the score
F1Race_Render_Score:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #40
	mov	r3, r0
	mov	r2, r1
	strh	r3, [fp, #-30]	
	mov	r3, r2	
	strh	r3, [fp, #-32]	
	ldr	r3, .RenderStatus
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #0
	mov	r2, #0
	mov	r1, #0
	bl	SDL_SetRenderDrawColor
	ldrsh	r3, [fp, #-30]
	add	r3, r3, #4
	str	r3, [fp, #-24]
	ldrsh	r3, [fp, #-32]
	add	r3, r3, #52
	str	r3, [fp, #-20]
	ldrsh	r3, [fp, #-30]
	add	r2, r3, #30
	ldr	r3, [fp, #-24]
	sub	r3, r2, r3
	str	r3, [fp, #-16]
	ldrsh	r3, [fp, #-32]
	add	r2, r3, #58
	ldr	r3, [fp, #-20]
	sub	r3, r2, r3
	str	r3, [fp, #-12]
	ldr	r3, .RenderStatus
	ldr	r3, [r3]
	sub	r2, fp, #24
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderFillRect
	ldr	r3, .RenderStatus+4
	ldrsh	r2, [r3]
	ldr	r3, .RenderStatus+8
	smull	r1, r3, r3, r2
	asr	r1, r3, #2
	asr	r3, r2, #31
	sub	r1, r1, r3
	mov	r3, r1
	lsl	r3, r3, #2
	add	r3, r3, r1
	lsl	r3, r3, #1
	sub	r3, r2, r3
	strh	r3, [fp, #-6]	
	ldr	r3, .RenderStatus+4
	ldrsh	r3, [r3]
	ldr	r2, .RenderStatus+8
	smull	r1, r2, r2, r3
	asr	r2, r2, #2
	asr	r3, r3, #31
	sub	r3, r2, r3
	strh	r3, [fp, #-8]	

@ a loop that draws and updates textures.
.F1Race_TextureDrawAndUpdate:
	ldrsh	r3, [fp, #-30]
	add	r0, r3, #25
	ldrsh	r3, [fp, #-32]
	add	r3, r3, #52
	ldrsh	r2, [fp, #-6]
	mov	r1, r3
	bl	Texture_Draw
	ldrh	r3, [fp, #-30]
	sub	r3, r3, #5
	strh	r3, [fp, #-30]	
	ldrsh	r3, [fp, #-8]
	cmp	r3, #0
	ble	.RestoreStackAndReturn
	ldrsh	r2, [fp, #-8]
	ldr	r3, .RenderStatus+8
	smull	r1, r3, r3, r2
	asr	r1, r3, #2
	asr	r3, r2, #31
	sub	r1, r1, r3
	mov	r3, r1
	lsl	r3, r3, #2
	add	r3, r3, r1
	lsl	r3, r3, #1
	sub	r3, r2, r3
	strh	r3, [fp, #-6]	
	ldrsh	r3, [fp, #-8]
	ldr	r2, .RenderStatus+8
	smull	r1, r2, r2, r3
	asr	r2, r2, #2
	asr	r3, r3, #31
	sub	r3, r2, r3
	strh	r3, [fp, #-8]	
	b	.F1Race_TextureDrawAndUpdate

@ deallocates stack space for local variables and restores the frame pointer and program counter to return control to the calling function.
.RestoreStackAndReturn:
	sub	sp, fp, #4
	pop	{fp, pc}

@ rendering status and score
.RenderStatus:
	.word	render
	.word	f1race_score
	.word	1717986919
	.size	F1Race_Render_Score, .-F1Race_Render_Score
	.align	2
	.type	F1Race_Render_Status, %function

@ render the status of the player. It sets up rendering parameters, calls functions to draw textures, and adjusts positions for rendering.
F1Race_Render_Status:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #32
	mov	r1, #3
	mov	r0, #92
	bl	F1Race_Render_Score
	ldr	r3, .Player_Car_Status_Counter
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #0
	mov	r2, #0
	mov	r1, #0
	bl	SDL_SetRenderDrawColor
	mov	r3, #96
	str	r3, [fp, #-28]
	mov	r3, #77
	str	r3, [fp, #-24]
	ldr	r3, [fp, #-28]
	rsb	r3, r3, #122
	str	r3, [fp, #-20]
	ldr	r3, [fp, #-24]
	rsb	r3, r3, #83
	str	r3, [fp, #-16]
	ldr	r3, .Player_Car_Status_Counter
	ldr	r3, [r3]
	sub	r2, fp, #28
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderFillRect
	mov	r3, #108
	strh	r3, [fp, #-8]	
	mov	r3, #77
	strh	r3, [fp, #-10]	
	ldrsh	r3, [fp, #-8]
	ldrsh	r1, [fp, #-10]
	ldr	r2, .Player_Car_Status_Counter+4
	ldrsh	r2, [r2]
	mov	r0, r3
	bl	Texture_Draw
	mov	r3, #96
	strh	r3, [fp, #-8]	
	mov	r3, #105
	strh	r3, [fp, #-10]	
	mov	r3, #0
	strh	r3, [fp, #-6]	
	b	.CheckValueAndDraw

@ checks if the player car's attribute value (r2) is greater than or equal to the maximum value (r3) and sets the rendering draw color accordingly, progressing to update rectangle positions.
.F1_Render_Car_Attribute:
	ldr	r3, .Player_Car_Status_Counter+8
	ldrsh	r3, [r3]
	ldrsh	r2, [fp, #-6]
	cmp	r2, r3
	bge	.F1Race_SetRenderDrawColor
	ldr	r3, .Player_Car_Status_Counter
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #0
	mov	r2, #0
	mov	r1, #255
	bl	SDL_SetRenderDrawColor
	b	.UpdateRectanglePositions
	
@ sets the rendering draw color for the player's car with RGB values (100, 100, 100).
.F1Race_SetRenderDrawColor:
	ldr	r3, .Player_Car_Status_Counter
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #100
	mov	r2, #100
	mov	r1, #100
	bl	SDL_SetRenderDrawColor
	
@  calculates and updates rectangle positions based on input attributes, then fills a rectangle using SDL_RenderFillRect, and increments a counter for the next iteration.
.UpdateRectanglePositions:
	ldrsh	r2, [fp, #-8]
	ldrsh	r3, [fp, #-6]
	lsl	r3, r3, #2
	add	r3, r2, r3
	str	r3, [fp, #-28]
	ldrsh	r3, [fp, #-10]
	sub	r2, r3, #2
	ldrsh	r3, [fp, #-6]
	sub	r3, r2, r3
	str	r3, [fp, #-24]
	ldrsh	r3, [fp, #-8]
	add	r2, r3, #2
	ldrsh	r3, [fp, #-6]
	lsl	r3, r3, #2
	add	r3, r2, r3
	add	r2, r3, #1
	ldr	r3, [fp, #-28]
	sub	r3, r2, r3
	str	r3, [fp, #-20]
	ldrsh	r2, [fp, #-10]
	ldr	r3, [fp, #-24]
	sub	r3, r2, r3
	str	r3, [fp, #-16]
	ldr	r3, .Player_Car_Status_Counter
	ldr	r3, [r3]
	sub	r2, fp, #28
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderFillRect
	ldrsh	r3, [fp, #-6]
	add	r3, r3, #1
	strh	r3, [fp, #-6]	
	
@ checks the value of r3 and either proceeds with rendering or sets specific attributes, then draws a texture using Texture_Draw.
.CheckValueAndDraw:
	ldrsh	r3, [fp, #-6]
	cmp	r3, #4
	ble	.F1_Render_Car_Attribute
	mov	r3, #117
	strh	r3, [fp, #-8]	
	mov	r3, #99
	strh	r3, [fp, #-10]	
	ldrsh	r3, [fp, #-8]
	ldrsh	r1, [fp, #-10]
	ldr	r2, .Player_Car_Status_Counter+12
	ldrsh	r2, [r2]
	mov	r0, r3
	bl	Texture_Draw
	sub	sp, fp, #4
	pop	{fp, pc}
	
@ hold status and counter values of the player's car in the game.
.Player_Car_Status_Counter:
	.word	render
	.word	f1race_level
	.word	f1race_fly_charger_count
	.word	f1race_fly_count
	.size	F1Race_Render_Status, .-F1Race_Render_Status
	.align	2
	.type	F1Race_Render_Player_Car, %function

@ Conditional checks and attribute adjustments for player car rendering.
F1Race_Render_Player_Car:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	ldr	r3, .F1Race_Render_Player_Car_Data_Update
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.Render_Player_car
	ldr	r3, .F1Race_Render_Player_Car_Data_Update+4
	ldrsh	r3, [r3]
	mov	r0, r3
	ldr	r3, .F1Race_Render_Player_Car_Data_Update+4
	ldrsh	r3, [r3, #2]
	mov	r2, #11
	mov	r1, r3
	bl	Texture_Draw
	b	.F1Race_Render_Player_Car_Cleanup
.Render_Player_car:
	mov	r3, #4
	strh	r3, [fp, #-10]	
	mov	r3, #3
	strh	r3, [fp, #-12]	
	ldr	r3, .F1Race_Render_Player_Car_Data_Update+4
	ldrsh	r3, [r3]
	uxth	r2, r3
	ldrh	r3, [fp, #-10]
	sub	r3, r2, r3
	strh	r3, [fp, #-10]	
	ldr	r3, .F1Race_Render_Player_Car_Data_Update+4
	ldrsh	r3, [r3, #2]
	uxth	r2, r3
	ldrh	r3, [fp, #-12]
	sub	r3, r2, r3
	strh	r3, [fp, #-12]	
	ldr	r3, .F1Race_Render_Player_Car_Data_Update+8
	ldrsh	r3, [r3]
	cmp	r3, #1
	bgt	.F1Race_CheckPowerUpActivation
	cmp	r3, #0
	bge	.F1Race_PlayerCarPowerUpRendering
	b	.F1Race_PlayerCarDataUpdateAndPowerUps
	
@ handle player fly
.F1Race_CheckPowerUpActivation:
	sub	r3, r3, #8
	cmp	r3, #1
	bhi	.F1Race_PlayerCarDataUpdateAndPowerUps
	b	.F1Race_PlayerCarPowerUp
	
@ render player fly
.F1Race_PlayerCarPowerUpRendering:
	mov	r3, #13
	str	r3, [fp, #-8]
	b	.F1Race_Render_Player_Car_PowerUp
	
@ activate fly state
.F1Race_PlayerCarPowerUp:
	mov	r3, #14
	str	r3, [fp, #-8]
	b	.F1Race_Render_Player_Car_PowerUp

@ update the fly state
.F1Race_PlayerCarDataUpdateAndPowerUps:
	mov	r3, #12
	str	r3, [fp, #-8]
	
@ rendering new fly state
.F1Race_Render_Player_Car_PowerUp:
	ldrsh	r3, [fp, #-10]
	ldrsh	r1, [fp, #-12]
	ldr	r2, [fp, #-8]
	mov	r0, r3
	bl	Texture_Draw
	
@ clean the fly state
.F1Race_Render_Player_Car_Cleanup:
	sub	sp, fp, #4
	pop	{fp, pc}
	
@Initilize Car status variable
.F1Race_Render_Player_Car_Data_Update:
	.word	f1race_player_is_car_fly
	.word	f1race_player_car
	.word	f1race_player_car_fly_duration
	.size	F1Race_Render_Player_Car, .-F1Race_Render_Player_Car
	.align	2
	.type	F1Race_Render_Opposite_Car, %function
	
@ render enemy car
F1Race_Render_Opposite_Car:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	mov	r3, #0
	strh	r3, [fp, #-6]	
	b	.F1Race_Check_Car_Position
	
@render crash state
.F1Race_Render_Opposite_Car_Crash_Update:
	ldrsh	r2, [fp, #-6]
	ldr	r1, .F1Race_Render_Opposite_Car_Crash
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #20
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.F1Race_Update_Car_Position
	ldrsh	r2, [fp, #-6]
	ldr	r1, .F1Race_Render_Opposite_Car_Crash
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #12
	ldrsh	r3, [r3]
	mov	r0, r3
	ldrsh	r2, [fp, #-6]
	ldr	r1, .F1Race_Render_Opposite_Car_Crash
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #14
	ldrsh	r3, [r3]
	mov	ip, r3
	ldrsh	r2, [fp, #-6]
	ldr	r1, .F1Race_Render_Opposite_Car_Crash
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #8
	ldr	r3, [r3]
	mov	r2, r3
	mov	r1, ip
	bl	Texture_Draw
	
@ update the car position
.F1Race_Update_Car_Position:
	ldrsh	r3, [fp, #-6]
	add	r3, r3, #1
	strh	r3, [fp, #-6]	
	
@ check player position
.F1Race_Check_Car_Position:
	ldrsh	r3, [fp, #-6]
	cmp	r3, #7
	ble	.F1Race_Render_Opposite_Car_Crash_Update
	sub	sp, fp, #4
	pop	{fp, pc}
	
@ call crash function
.F1Race_Render_Opposite_Car_Crash:
	.word	f1race_opposite_car
	.size	F1Race_Render_Opposite_Car, .-F1Race_Render_Opposite_Car
	.align	2
	.type	F1Race_Render_Player_Car_Crash, %function
	
@ render crash state of player
F1Race_Render_Player_Car_Crash:
	push	{fp, lr}
	add	fp, sp, #4
	ldr	r3, .F1Race_Render_Player_Car_Crash
	ldrsh	r3, [r3]
	mov	r0, r3
	ldr	r3, .F1Race_Render_Player_Car_Crash
	ldrsh	r3, [r3, #2]
	sub	r3, r3, #5
	mov	r2, #16
	mov	r1, r3
	bl	Texture_Draw
	pop	{fp, pc}
	
@ declare variables for rendering player car crash
.F1Race_Render_Player_Car_Crash:
	.word	f1race_player_car
	.size	F1Race_Render_Player_Car_Crash, .-F1Race_Render_Player_Car_Crash
	.align	2
	.type	F1Race_Render, %function
	
@ render screen
F1Race_Render:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	mov	r3, #92
	str	r3, [fp, #-20]
	mov	r3, #3
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-20]
	rsb	r3, r3, #125
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-16]
	rsb	r3, r3, #124
	str	r3, [fp, #-8]
	ldr	r3, .F1Race_Render
	ldr	r3, [r3]
	sub	r2, fp, #20
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderSetClipRect
	bl	F1Race_Render_Status
	mov	r3, #10
	str	r3, [fp, #-20]
	mov	r3, #3
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-20]
	rsb	r3, r3, #85
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-16]
	rsb	r3, r3, #124
	str	r3, [fp, #-8]
	ldr	r3, .F1Race_Render
	ldr	r3, [r3]
	sub	r2, fp, #20
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderSetClipRect
	bl	F1Race_Render_Road
	bl	F1Race_Render_Separator
	bl	F1Race_Render_Opposite_Car
	bl	F1Race_Render_Player_Car	
	sub	sp, fp, #4
	pop	{fp, pc}

@define labels and directives for background
.F1Race_Render:
	.word	render
	.size	F1Race_Render, .-F1Race_Render
	.align	2
	.type	F1Race_Render_Background, %function
	
@ render the background
F1Race_Render_Background:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	ldr	r3, .F1Race_Render_Background
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #255
	mov	r2, #255
	mov	r1, #255
	bl	SDL_SetRenderDrawColor
	ldr	r3, .F1Race_Render_Background
	ldr	r3, [r3]
	mov	r0, r3
	bl	SDL_RenderClear
	ldr	r3, .F1Race_Render_Background
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #0
	mov	r2, #0
	mov	r1, #0
	bl	SDL_SetRenderDrawColor
	mov	r3, #2
	str	r3, [fp, #-20]
	mov	r3, #2
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-20]
	rsb	r3, r3, #126
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-16]
	rsb	r3, r3, #125
	str	r3, [fp, #-8]
	ldr	r3, .F1Race_Render_Background
	ldr	r3, [r3]
	sub	r2, fp, #20
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderDrawRect
	ldr	r3, .F1Race_Render_Background
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #0
	mov	r2, #0
	mov	r1, #0
	bl	SDL_SetRenderDrawColor
	mov	r3, #3
	str	r3, [fp, #-20]
	mov	r3, #3
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-20]
	rsb	r3, r3, #10
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-16]
	rsb	r3, r3, #124
	str	r3, [fp, #-8]
	ldr	r3, .F1Race_Render_Background
	ldr	r3, [r3]
	sub	r2, fp, #20
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderFillRect
	ldr	r3, .F1Race_Render_Background
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #255
	mov	r2, #255
	mov	r1, #255
	bl	SDL_SetRenderDrawColor
	ldr	r3, .F1Race_Render_Background
	ldr	r0, [r3]
	mov	r3, #123
	str	r3, [sp]
	mov	r3, #8
	mov	r2, #3
	mov	r1, #8
	bl	SDL_RenderDrawLine
	ldr	r3, .F1Race_Render_Background
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #0
	mov	r2, #0
	mov	r1, #0
	bl	SDL_SetRenderDrawColor
	ldr	r3, .F1Race_Render_Background
	ldr	r0, [r3]
	mov	r3, #124
	str	r3, [sp]
	mov	r3, #9
	mov	r2, #3
	mov	r1, #9
	bl	SDL_RenderDrawLine
	ldr	r3, .F1Race_Render_Background
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #0
	mov	r2, #0
	mov	r1, #0
	bl	SDL_SetRenderDrawColor
	mov	r3, #85
	str	r3, [fp, #-20]
	mov	r3, #3
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-20]
	rsb	r3, r3, #92
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-16]
	rsb	r3, r3, #124
	str	r3, [fp, #-8]
	ldr	r3, .F1Race_Render_Background
	ldr	r3, [r3]
	sub	r2, fp, #20
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderFillRect
	ldr	r3, .F1Race_Render_Background
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #255
	mov	r2, #255
	mov	r1, #255
	bl	SDL_SetRenderDrawColor
	ldr	r3, .F1Race_Render_Background
	ldr	r0, [r3]
	mov	r3, #123
	str	r3, [sp]
	mov	r3, #86
	mov	r2, #3
	mov	r1, #86
	bl	SDL_RenderDrawLine
	ldr	r3, .F1Race_Render_Background
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #0
	mov	r2, #0
	mov	r1, #0
	bl	SDL_SetRenderDrawColor
	ldr	r3, .F1Race_Render_Background
	ldr	r0, [r3]
	mov	r3, #124
	str	r3, [sp]
	mov	r3, #85
	mov	r2, #3
	mov	r1, #85
	bl	SDL_RenderDrawLine
	ldr	r3, .F1Race_Render_Background
	ldr	r0, [r3]
	mov	r3, #0
	str	r3, [sp]
	mov	r3, #0
	mov	r2, #0
	mov	r1, #0
	bl	SDL_SetRenderDrawColor
	mov	r3, #92
	str	r3, [fp, #-20]
	mov	r3, #3
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-20]
	rsb	r3, r3, #125
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-16]
	rsb	r3, r3, #124
	str	r3, [fp, #-8]
	ldr	r3, .F1Race_Render_Background
	ldr	r3, [r3]
	sub	r2, fp, #20
	mov	r1, r2
	mov	r0, r3
	bl	SDL_RenderFillRect
	mov	r2, #17
	mov	r1, #3
	mov	r0, #92
	bl	Texture_Draw
	mov	r2, #18
	mov	r1, #45
	mov	r0, #97
	bl	Texture_Draw
	mov	r2, #19
	mov	r1, #53
	mov	r0, #94
	bl	Texture_Draw
	mov	r2, #20
	mov	r1, #67
	mov	r0, #98
	bl	Texture_Draw
	mov	r2, #19
	mov	r1, #75
	mov	r0, #94
	bl	Texture_Draw
	mov	r2, #21
	mov	r1, #92
	mov	r0, #94
	bl	Texture_Draw
	sub	sp, fp, #4
	pop	{fp, pc}
	
@determine size directives for background render label
.F1Race_Render_Background:
	.word	render
	.size	F1Race_Render_Background, .-F1Race_Render_Background
	
@ ----------- INIT CODE ----------------
	.align	2
	.type	F1Race_Init, %function
@ handle init
F1Race_Init:
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #12
	ldr	r3, .F1Race_Initialization_Handler
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1Race_Initialization_Handler+4
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1Race_Initialization_Handler+8
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1Race_Initialization_Handler+12
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1Race_Initialization_Handler+16
	mov	r2, #3
	strh	r2, [r3]	
	ldr	r3, .F1Race_Initialization_Handler+20
	mov	r2, #12
	strh	r2, [r3]	
	ldr	r3, .F1Race_Initialization_Handler+24
	mov	r2, #39
	strh	r2, [r3]	
	ldr	r3, .F1Race_Initialization_Handler+24
	mov	r2, #15
	strh	r2, [r3, #4]	
	ldr	r3, .F1Race_Initialization_Handler+24
	mov	r2, #103
	strh	r2, [r3, #2]	
	ldr	r3, .F1Race_Initialization_Handler+24
	mov	r2, #20
	strh	r2, [r3, #6]	
	ldr	r3, .F1Race_Initialization_Handler+24
	mov	r2, #11
	str	r2, [r3, #8]
	ldr	r3, .F1Race_Initialization_Handler+24
	mov	r2, #12
	str	r2, [r3, #12]
	ldr	r3, .F1Race_Initialization_Handler+24
	mov	r2, #15
	str	r2, [r3, #16]
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #17
	strh	r2, [r3]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #35
	strh	r2, [r3, #2]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #22
	str	r2, [r3, #8]
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #3
	strh	r2, [r3, #4]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #3
	strh	r2, [r3, #6]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #12
	strh	r2, [r3, #12]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #18
	strh	r2, [r3, #14]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #23
	str	r2, [r3, #20]
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #4
	strh	r2, [r3, #16]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #5
	strh	r2, [r3, #18]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #15
	strh	r2, [r3, #24]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #20
	strh	r2, [r3, #26]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #24
	str	r2, [r3, #32]
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #6
	strh	r2, [r3, #28]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #4
	strh	r2, [r3, #30]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #12
	strh	r2, [r3, #36]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #18
	strh	r2, [r3, #38]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #25
	str	r2, [r3, #44]
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #3
	strh	r2, [r3, #40]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #5
	strh	r2, [r3, #42]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #17
	strh	r2, [r3, #48]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #27
	strh	r2, [r3, #50]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #26
	str	r2, [r3, #56]
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #3
	strh	r2, [r3, #52]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #3
	strh	r2, [r3, #54]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #13
	strh	r2, [r3, #60]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #21
	strh	r2, [r3, #62]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #27
	str	r2, [r3, #68]
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #5
	strh	r2, [r3, #64]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #5
	strh	r2, [r3, #66]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #13
	strh	r2, [r3, #72]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #22
	strh	r2, [r3, #74]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #28
	str	r2, [r3, #80]
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #3
	strh	r2, [r3, #76]	
	ldr	r3, .F1Race_Initialization_Handler+28
	mov	r2, #5
	strh	r2, [r3, #78]	
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.F1Race_Initialization_Handler_Flow_Control
@ initialize and update
.F1Race_Initialization_Handler_State_Update:
	ldr	r1, .F1Race_Initialization_Handler+32
	ldr	r2, [fp, #-8]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #20
	mov	r2, #1
	str	r2, [r3]
	ldr	r1, .F1Race_Initialization_Handler+32
	ldr	r2, [fp, #-8]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #24
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
@ handle coode flow
.F1Race_Initialization_Handler_Flow_Control:
	ldr	r3, [fp, #-8]
	cmp	r3, #7
	ble	.F1Race_Initialization_Handler_State_Update
	ldr	r3, .F1Race_Initialization_Handler+36
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1Race_Initialization_Handler+40
	mov	r2, #0
	strh	r2, [r3]	
	ldr	r3, .F1Race_Initialization_Handler+44
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1Race_Initialization_Handler+48
	mov	r2, #0
	strh	r2, [r3]	
	ldr	r3, .F1Race_Initialization_Handler+52
	mov	r2, #1
	strh	r2, [r3]	
	ldr	r3, .F1Race_Initialization_Handler+56
	mov	r2, #0
	strh	r2, [r3]	
	ldr	r3, .F1Race_Initialization_Handler+60
	mov	r2, #1
	strh	r2, [r3]	
	ldr	r3, .F1Race_Initialization_Handler+64
	mov	r2, #0
	strh	r2, [r3]	
	add	sp, fp, #0
	ldr	fp, [sp], #4
	bx	lr
@ stores the initialization values for the F1 Race sprite control and etc.
.F1Race_Initialization_Handler:
	.word	f1race_key_up_pressed
	.word	f1race_key_down_pressed
	.word	f1race_key_right_pressed
	.word	f1race_key_pressed
	.word	f1race_separator_0_block_start_y
	.word	f1race_separator_1_block_start_y
	.word	f1race_player_car
	.word	f1race_opposite_car_type
	.word	f1race_opposite_car
	.word	f1race_is_crashing
	.word	f1race_last_car_road
	.word	f1race_player_is_car_fly
	.word	f1race_score
	.word	f1race_level
	.word	f1race_pass
	.word	f1race_fly_count
	.word	f1race_fly_charger_count
	.size	F1Race_Init, .-F1Race_Init

	.align	2
	.type	F1Race_Main, %function
F1Race_Main:
	push	{fp, lr}
	add	fp, sp, #4
	ldr	r3, .Data_Section
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.RenderBackground
	bl	F1Race_Init
	ldr	r3, .Data_Section
	mov	r2, #0
	str	r2, [r3]
@rendering background with music
.RenderBackground:
	bl	F1Race_Render_Background
	bl	F1Race_Render
	ldr	r3, .Data_Section+4
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.StartMusic
	mvn	r1, #0
	mov	r0, #0
	bl	Music_Play
	b	.Exitfunction
@ start music
.StartMusic:
	mvn	r1, #0
	mov	r0, #1
	bl	Music_Play
@ exit music
.Exitfunction:
	pop	{fp, pc}
.Data_Section:
	.word	f1race_is_new_game
	.word	using_new_background_ogg
	.size	F1Race_Main, .-F1Race_Main

	.align	2
	.type	F1Race_Key_Pressed, %function

@ Initializing the variable for control key
F1Race_Key_Pressed:
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	ldr	r3, .Table_key
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .Table_key+4
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .Table_key+8
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .Table_key+12
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .Table_key+16
	ldr	r3, [r3]
	cmp	r3, #1
	beq	.NoOperation2
	ldr	r3, .Table_key+8
	mov	r2, #1
	str	r2, [r3]
	b	.CleanupAndReturn
.NoOperation2:
	nop
@ clean and return
.CleanupAndReturn:
	add	sp, fp, #0
	ldr	fp, [sp], #4
	bx	lr
@ intialize key table
.Table_key:
	.word	f1race_key_up_pressed
	.word	f1race_key_down_pressed
	.word	f1race_key_pressed
	.word	f1race_key_right_pressed
	.word	f1race_is_crashing
	.size	F1Race_Key_Pressed, .-F1Race_Key_Pressed
	.align	2
	.type	F1Race_Key_Left_Released, %function
@
F1Race_Key_Left_Released:
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	ldr	r3, .KeyLeft_pressed
	mov	r2, #0
	str	r2, [r3]
	
	add	sp, fp, #0
	ldr	fp, [sp], #4
	bx	lr
.KeyLeft_pressed:
	.word	f1race_key_pressed
	.size	F1Race_Key_Left_Released, .-F1Race_Key_Left_Released
	.align	2
	.type	F1Race_Key_Right_Pressed, %function
@ Handle the press of the right key in the F1 racing game
F1Race_Key_Right_Pressed:
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	ldr	r3, .F1Race_Process_Key_Release
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1Race_Process_Key_Release+4
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1Race_Process_Key_Release+8
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1Race_Process_Key_Release+12
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1Race_Process_Key_Release+16
	ldr	r3, [r3]
	cmp	r3, #1
	beq	.NoOperation4
	ldr	r3, .F1Race_Process_Key_Release+12
	mov	r2, #1
	str	r2, [r3]
	b	.CleanupAndReturn2
.NoOperation4:
	nop
.CleanupAndReturn2:
	add	sp, fp, #0
	ldr	fp, [sp], #4
	bx	lr
.F1Race_Process_Key_Release:
	.word	f1race_key_up_pressed
	.word	f1race_key_down_pressed
	.word	f1race_key_pressed
	.word	f1race_key_right_pressed
	.word	f1race_is_crashing
	.size	F1Race_Key_Right_Pressed, .-F1Race_Key_Right_Pressed
	.align	2
	.type	F1Race_Key_Right_Released, %function
@ handles the release of the right key 
F1Race_Key_Right_Released:
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	ldr	r3, .F1Race_Key_Right_Pressed_Handler
	mov	r2, #0
	str	r2, [r3]
	add	sp, fp, #0
	ldr	fp, [sp], #4
	bx	lr
	
.F1Race_Key_Right_Pressed_Handler:
	.word	f1race_key_right_pressed
	.size	F1Race_Key_Right_Released, .-F1Race_Key_Right_Released
	.align	2
	.type	F1Race_Key_Up_Pressed, %function
F1Race_Key_Up_Pressed:
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	ldr	r3, .F1Race_Key_Up_Released2
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1Race_Key_Up_Released2+4
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1Race_Key_Up_Released2+8
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1Race_Key_Up_Released2+12
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1Race_Key_Up_Released2+16
	ldr	r3, [r3]
	cmp	r3, #1
	beq	.NoOperation9
	ldr	r3, .F1Race_Key_Up_Released2
	mov	r2, #1
	str	r2, [r3]
	b	.FunctionExit
.NoOperation9:
	nop
@ exit key
.FunctionExit:
	add	sp, fp, #0
	ldr	fp, [sp], #4
	bx	lr
@ call key up function
.F1Race_Key_Up_Released2:
	.word	f1race_key_up_pressed
	.word	f1race_key_down_pressed
	.word	f1race_key_pressed
	.word	f1race_key_right_pressed
	.word	f1race_is_crashing
	.size	F1Race_Key_Up_Pressed, .-F1Race_Key_Up_Pressed
	.align	2
	.type	F1Race_Key_Up_Released, %function
@ key up release function
F1Race_Key_Up_Released:
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	ldr	r3, .F1Race_Key_Down_Pressed2
	mov	r2, #0
	str	r2, [r3]
	add	sp, fp, #0
	ldr	fp, [sp], #4
	bx	lr
@ call down pressed function
.F1Race_Key_Down_Pressed2:
	.word	f1race_key_up_pressed
	.size	F1Race_Key_Up_Released, .-F1Race_Key_Up_Released
	.align	2
	.type	F1Race_Key_Down_Pressed, %function
@ key down pressed function
F1Race_Key_Down_Pressed:
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	ldr	r3, .HandleKeyReleasedActions
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .HandleKeyReleasedActions+4
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .HandleKeyReleasedActions+8
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .HandleKeyReleasedActions+12
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .HandleKeyReleasedActions+16
	ldr	r3, [r3]
	cmp	r3, #1
	beq	.NoOperation
	ldr	r3, .HandleKeyReleasedActions+4
	mov	r2, #1
	str	r2, [r3]
	b	.FunctionReturn
.NoOperation:
	nop
@ return function
.FunctionReturn:
	add	sp, fp, #0
	ldr	fp, [sp], #4
	bx	lr
@ initialize key functions 
.HandleKeyReleasedActions:
	.word	f1race_key_up_pressed
	.word	f1race_key_down_pressed
	.word	f1race_key_pressed
	.word	f1race_key_right_pressed
	.word	f1race_is_crashing
	.size	F1Race_Key_Down_Pressed, .-F1Race_Key_Down_Pressed
	.align	2
	.type	F1Race_Key_Down_Released, %function
F1Race_Key_Down_Released:
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	ldr	r3, .HandleFlyingKeyAction
	mov	r2, #0
	str	r2, [r3]
	add	sp, fp, #0
	ldr	fp, [sp], #4
	bx	lr
.HandleFlyingKeyAction:
	.word	f1race_key_down_pressed
	.size	F1Race_Key_Down_Released, .-F1Race_Key_Down_Released
	.align	2
	.type	F1Race_Key_Fly_Pressed, %function
F1Race_Key_Fly_Pressed:
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	ldr	r3, .FlyVariables
	ldr	r3, [r3]
	cmp	r3, #0
	ldr	r3, .FlyVariables+4
	ldrsh	r3, [r3]
	cmp	r3, #0
	ble	.FunctionEnd
	ldr	r3, .FlyVariables
	mov	r2, #1
	str	r2, [r3]
	ldr	r3, .FlyVariables+8
	mov	r2, #0
	strh	r2, [r3]	
	ldr	r3, .FlyVariables+4
	ldrsh	r3, [r3]
	sub	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .FlyVariables+4
	strh	r3, [r2]	
	b	.FunctionEnd
.FunctionEnd:
	add	sp, fp, #0
	ldr	fp, [sp], #4
	bx	lr
.FlyVariables:
	.word	f1race_player_is_car_fly
	.word	f1race_fly_count
	.word	f1race_player_car_fly_duration
	.size	F1Race_Key_Fly_Pressed, .-F1Race_Key_Fly_Pressed
	.align	2
	.type	F1Race_Keyboard_Key_Handler, %function
F1Race_Keyboard_Key_Handler:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	str	r0, [fp, #-8]
	str	r1, [fp, #-12]
	ldr	r3, [fp, #-8]
	ldr	r2, .GameDataInitializer
	cmp	r3, r2
	bgt	.EndHandler
	ldr	r3, [fp, #-8]
	ldr	r2, .GameDataInitializer+4
	cmp	r3, r2
	bge	.DynamicJumpHandler
	ldr	r3, [fp, #-8]
	cmp	r3, #110
	beq	.MusicConditionHandler
	ldr	r3, [fp, #-8]
	cmp	r3, #110
	bgt	.EndHandler
	ldr	r3, [fp, #-8]
	cmp	r3, #56
	bgt	.CharacterActionCheck
	ldr	r3, [fp, #-8]
	cmp	r3, #9

@ -------- Main LOGIC -----------
	bge	.ActionRangeHandler
	b	.EndHandler
.DynamicJumpHandler:
	ldr	r3, [fp, #-8]
	add	r3, r3, #-1073741824
	sub	r3, r3, #79
	cmp	r3, #19
	ldrls	pc, [pc, r3, asl #2]
	b	.EndHandler
.ActionDispatchTable:
	.word	.HandleRightKeypress
	.word	.HandleLeftKeyPress
	.word	.F1Race_Key_Down_Release_Or_Press_Handling
	.word	.HandleKeyUpPressed
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.F1Race_Key_Fly_Press_Handling
	.word	.EndHandler
	.word	.F1Race_Key_Down_Release_Or_Press_Handling
	.word	.EndHandler
	.word	.HandleLeftKeyPress
	.word	.F1Race_Key_Fly_Press_Handling
	.word	.HandleRightKeypress
	.word	.MusicVolumeControl
	.word	.HandleKeyUpPressed
	.word	.EndHandler
	.word	.MusicConditionHandler
.ActionRangeHandler:
	ldr	r3, [fp, #-8]
	sub	r3, r3, #9
	cmp	r3, #47
	ldrls	pc, [pc, r3, asl #2]
	b	.EndHandler
.ActionDispatchTable2:
	.word	.MusicConditionHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.F1Race_Key_Fly_Press_Handling
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.SetMusic
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.F1Race_Key_Fly_Press_Handling
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.EndHandler
	.word	.MusicConditionHandler
	.word	.EndHandler
	.word	.HandleKeyUpPressed
	.word	.EndHandler
	.word	.EndHandler
	.word	.F1Race_Key_Fly_Press_Handling
	.word	.EndHandler
	.word	.MusicVolumeControl
	.word	.F1Race_Key_Down_Release_Or_Press_Handling

.CharacterActionCheck:
	ldr	r3, [fp, #-8]
	cmp	r3, #109
	beq	.MusicVolumeControl
	b	.EndHandler
.HandleLeftKeyPress:
	ldr	r3, [fp, #-12]
	cmp	r3, #0
	beq	.HandleKeyLeftReleased
	bl	F1Race_Key_Pressed
	b	.NoOperation6
.HandleKeyLeftReleased:
	bl	F1Race_Key_Left_Released
	b	.NoOperation6
.HandleRightKeypress:
	ldr	r3, [fp, #-12]
	cmp	r3, #0
	beq	.HandleRightKeyReleased
	bl	F1Race_Key_Right_Pressed
	b	.NoOperation6
.HandleRightKeyReleased:
	bl	F1Race_Key_Right_Released
	b	.NoOperation6
.HandleKeyUpPressed:
	ldr	r3, [fp, #-12]
	cmp	r3, #0
	beq	.HandleKeyUpReleased
	bl	F1Race_Key_Up_Pressed
	b	.NoOperation6
.HandleKeyUpReleased:
	bl	F1Race_Key_Up_Released
	b	.NoOperation6
.F1Race_Key_Down_Release_Or_Press_Handling:
	ldr	r3, [fp, #-12]
	cmp	r3, #0
	beq	.F1Race_Key_Down_Press_Handling
	bl	F1Race_Key_Down_Pressed
	b	.NoOperation6
.F1Race_Key_Down_Press_Handling:
	bl	F1Race_Key_Down_Released
	b	.NoOperation6
.F1Race_Key_Fly_Press_Handling:
	ldr	r3, [fp, #-12]
	cmp	r3, #0
	beq	.EndState
	bl	F1Race_Key_Fly_Pressed
	b	.EndState
.MusicConditionHandler:
	ldr	r3, [fp, #-12]
	cmp	r3, #0
	beq	.MusicEnd
	ldr	r3, .GameDataInitializer+8
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.PlayMusic2
	mvn	r1, #0
	mov	r0, #0
	bl	Music_Play
	b	.UpdateMusicVolume
.PlayMusic2:
	mvn	r1, #0
	mov	r0, #1
	bl	Music_Play
.UpdateMusicVolume:
	ldr	r3, .GameDataInitializer+8
	ldr	r3, [r3]
	cmp	r3, #0
	moveq	r3, #1
	movne	r3, #0
	uxtb	r3, r3
	mov	r2, r3
	ldr	r3, .GameDataInitializer+8
	str	r2, [r3]
	b	.MusicEnd
.MusicVolumeControl:
	ldr	r3, [fp, #-12]
	cmp	r3, #0
	beq	.MusicEnd2
	ldr	r3, .GameDataInitializer+12
	ldr	r3, [r3]
	cmn	r3, #1
	bne	.MusicVolumeHandler
	mov	r0, #0
	bl	Mix_VolumeMusic
	mov	r3, r0
	ldr	r2, .GameDataInitializer+12
	str	r3, [r2]
	b	.MusicEnd2
.MusicVolumeHandler:
	ldr	r3, .GameDataInitializer+12
	ldr	r3, [r3]
	mov	r0, r3
	bl	Mix_VolumeMusic
	ldr	r3, .GameDataInitializer+12
	mvn	r2, #0
	str	r2, [r3]
	b	.MusicEnd2
.SetMusic:
	ldr	r3, [fp, #-12]
	cmp	r3, #0
	beq	.NoOperation5
	ldr	r3, .GameDataInitializer+16
	mov	r2, #1
	str	r2, [r3]
	b	.NoOperation5
.EndState:
	b	.EndHandler
.MusicEnd:
	b	.EndHandler
.MusicEnd2:
	b	.EndHandler
.NoOperation5:
	nop
.NoOperation6:
	nop
.EndHandler:
	sub	sp, fp, #4
	pop	{fp, pc}
.GameDataInitializer:
	.word	1073741922
	.word	1073741903
	.word	using_new_background_ogg
	.word	volume_old
	.word	exit_main_loop
	.size	F1Race_Keyboard_Key_Handler, .-F1Race_Keyboard_Key_Handler

@ ------------- CRASHING ------------------
	.align	2
	.type	F1Race_Crashing, %function
F1Race_Crashing:
	push	{fp, lr}
	add	fp, sp, #4
	mov	r1, #0
	mov	r0, #2
	bl	Music_Play
	ldr	r3, .UpdateGameCrashState
	mov	r2, #1
	str	r2, [r3]
	ldr	r3, .UpdateGameCrashState+4
	mov	r2, #50
	strh	r2, [r3]	
	pop	{fp, pc}
@ update game state when car crashes
.UpdateGameCrashState:
	.word	f1race_is_crashing
	.word	f1race_crashing_count_down
	.size	F1Race_Crashing, .-F1Race_Crashing
	.align	2
	.type	F1Race_New_Opposite_Car, %function

@ Initializing opposite car
F1Race_New_Opposite_Car:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	mov	r3, #0
	strh	r3, [fp, #-8]	
	mov	r3, #0
	strh	r3, [fp, #-12]	
	mov	r3, #0
	strh	r3, [fp, #-16]	
	mov	r3, #1
	strh	r3, [fp, #-10]	
	bl	rand
	mov	r3, r0
	and	r3, r3, #1
	cmp	r3, #0
	bne	.CollisionHandle
	mov	r3, #0
	strh	r3, [fp, #-6]	
	b	.CheckPlayerCarSpeedLimit
@ check crash and increase speed
.CheckOppositeCarCollisionAndSpeedIncreasing:
	ldrsh	r2, [fp, #-6]
	ldr	r1, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #20
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.IncreasedPlayer_CarSpeed
	ldrh	r3, [fp, #-6]	
	strh	r3, [fp, #-8]	
	mov	r3, #0
	strh	r3, [fp, #-10]	
	b	.CollisionHandle
@ increase player car speed
.IncreasedPlayer_CarSpeed:
	ldrsh	r3, [fp, #-6]
	add	r3, r3, #1
	strh	r3, [fp, #-6]	
.CheckPlayerCarSpeedLimit:
	ldrsh	r3, [fp, #-6]
	cmp	r3, #7
	ble	.CheckOppositeCarCollisionAndSpeedIncreasing
.CollisionHandle:
	ldrsh	r3, [fp, #-10]
	cmp	r3, #0
	bne	.BranchToReturn2
	bl	rand
	mov	r2, r0
	ldr	r3, .CheckOppositeCarCollision+4
	smull	r3, r1, r3, r2
	asr	r3, r2, #31
	sub	r1, r1, r3
	mov	r3, r1
	lsl	r3, r3, #1
	add	r3, r3, r1
	sub	r1, r2, r3
	mov	r3, r1
	strb	r3, [fp, #-13]
	ldrb	r3, [fp, #-13]
	ldr	r2, .CheckOppositeCarCollision+8
	ldrsh	r2, [r2]
	cmp	r3, r2
	bne	.RaceModeAcceleration
	ldrb	r3, [fp, #-13]
	add	r3, r3, #1
	strb	r3, [fp, #-13]
	ldrb	r2, [fp, #-13]
	ldr	r3, .CheckOppositeCarCollision+12
	umull	r1, r3, r3, r2
	lsr	r1, r3, #1
	mov	r3, r1
	lsl	r3, r3, #1
	add	r3, r3, r1
	sub	r3, r2, r3
	strb	r3, [fp, #-13]
.RaceModeAcceleration:
	ldr	r3, .CheckOppositeCarCollision+16
	ldrsh	r3, [r3]
	cmp	r3, #2
	bgt	.NoOperation8
	bl	rand
	mov	r1, r0
	ldr	r3, .CheckOppositeCarCollision+20
	smull	r2, r3, r3, r1
	asr	r2, r3, #1
	asr	r3, r1, #31
	sub	r2, r2, r3
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	sub	r2, r1, r3
	strh	r2, [fp, #-20]	
	ldrsh	r3, [fp, #-20]
	cmp	r3, #10
	ldrls	pc, [pc, r3, asl #2]
	b	.GenerateOpponentCarSpeed
@ define labels and directive for opponent car's speed
.SpeedSettingTable:
	.word	.SpeedCar_Opponent0
	.word	.SpeedCar_Opponent0
	.word	.SpeedCar_Opponent1
	.word	.SpeedCar_Opponent1
	.word	.SpeedCar_Opponent1
	.word	.SpeedCar_Opponent2
	.word	.SpeedCar_Opponent3
	.word	.SpeedCar_Opponent3
	.word	.SpeedCar_Opponent4
	.word	.SpeedCar_Opponent5
	.word	.SpeedCar_Opponent6
@ set the incoming opponent0 car speed
.SpeedCar_Opponent0:
	mov	r3, #0
	strh	r3, [fp, #-12]	
	b	.GenerateOpponentCarSpeed
@ set the incoming opponent1 car speed
.SpeedCar_Opponent1:
	mov	r3, #1
	strh	r3, [fp, #-12]	
	b	.GenerateOpponentCarSpeed
@ set the incoming opponent2 car speed
.SpeedCar_Opponent2:
	mov	r3, #2
	strh	r3, [fp, #-12]	
	b	.GenerateOpponentCarSpeed
@ set the incoming opponent3 car speed
.SpeedCar_Opponent3:
	mov	r3, #3
	strh	r3, [fp, #-12]	
	b	.GenerateOpponentCarSpeed
@ set the incoming opponent4 car speed
.SpeedCar_Opponent4:
	mov	r3, #4
	strh	r3, [fp, #-12]	
	b	.GenerateOpponentCarSpeed
@ set the incoming opponent5 car speed
.SpeedCar_Opponent5:
	mov	r3, #5
	strh	r3, [fp, #-12]	
	b	.GenerateOpponentCarSpeed
@ set the incoming opponent6 car speed
.SpeedCar_Opponent6:
	mov	r3, #6
	strh	r3, [fp, #-12]	
	b	.GenerateOpponentCarSpeed
.NoOperation8:
	nop
@ set the speed of the opponent's car, change its behavior and change the game state
.GenerateOpponentCarSpeed:
	ldr	r3, .CheckOppositeCarCollision+16
	ldrsh	r3, [r3]
	cmp	r3, #2
	ble	.NoOperation7
	bl	rand
	mov	r1, r0
	ldr	r3, .CheckOppositeCarCollision+20
	smull	r2, r3, r3, r1
	asr	r2, r3, #1
	asr	r3, r1, #31
	sub	r2, r2, r3
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	sub	r2, r1, r3
	strh	r2, [fp, #-20]	
	ldrsh	r3, [fp, #-20]
	cmp	r3, #10
	ldrls	pc, [pc, r3, asl #2]
	b	.InitializeGameState
@ define labels and directive for game difficulty
.GameDifficultyTable:
	.word	.SetGameDifficultTo0
	.word	.SetGameDifficultTo1
	.word	.SetGameDifficultTo1
	.word	.SetGameDifficultTo2
	.word	.SetGameDifficultTo2
	.word	.SetGameDifficultTo3
	.word	.SetGameDifficultTo3
	.word	.SetGameDifficultTo4
	.word	.SetGameDifficultTo5
	.word	.SetGameDifficultTo5
	.word	.SetGameDifficultTo6
@ set game difficulty level to 0
.SetGameDifficultTo0:
	mov	r3, #0
	strh	r3, [fp, #-12]	
	b	.InitializeGameState
@ set game difficulty level to 1
.SetGameDifficultTo1:
	mov	r3, #1
	strh	r3, [fp, #-12]	
	b	.InitializeGameState
@ set game difficulty level to 2
.SetGameDifficultTo2:
	mov	r3, #2
	strh	r3, [fp, #-12]	
	b	.InitializeGameState
@ set game difficulty level to 3
.SetGameDifficultTo3:
	mov	r3, #3
	strh	r3, [fp, #-12]	
	b	.InitializeGameState
@ set game difficulty level to 4
.SetGameDifficultTo4:
	mov	r3, #4
	strh	r3, [fp, #-12]	
	b	.InitializeGameState
@ set game difficulty level to 5
.SetGameDifficultTo5:
	mov	r3, #5
	strh	r3, [fp, #-12]	
	b	.InitializeGameState
@ set game difficulty level to 6
.SetGameDifficultTo6:
	mov	r3, #6
	strh	r3, [fp, #-12]	
	b	.InitializeGameState
.NoOperation7:
	nop
@ initializes certain game state variables or flags, then proceeds to another part of the game logic.
.InitializeGameState:
	mov	r3, #1
	strh	r3, [fp, #-18]	
	mov	r3, #0
	strh	r3, [fp, #-6]	
	b	.VehicularSkirmish
@ check for the player car and opponent car collision
.CheckPlayerCarVsOpponent:
	ldrsh	r2, [fp, #-6]
	ldr	r1, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #20
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.IncreasePlayerCarSpeed
	ldrsh	r2, [fp, #-6]
	ldr	r1, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #14
	ldrsh	r3, [r3]
	cmp	r3, #29
	bgt	.IncreasePlayerCarSpeed
	mov	r3, #0
	strh	r3, [fp, #-18]	
@ increase the player's car speed
.IncreasePlayerCarSpeed:
	ldrsh	r3, [fp, #-6]
	add	r3, r3, #1
	strh	r3, [fp, #-6]	
@ responsible for managing a vehicular skirmish or collision
.VehicularSkirmish:
	ldrsh	r3, [fp, #-6]
	cmp	r3, #7
	ble	.CheckPlayerCarVsOpponent
	ldrsh	r3, [fp, #-18]
	cmp	r3, #0
	beq	.NoOperation3
	ldr	r3, .CheckOppositeCarCollision+16
	ldrsh	r3, [r3]
	sub	r3, r3, #1
	strh	r3, [fp, #-22]	
	ldrsh	r2, [fp, #-8]
	ldr	r1, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #20
	mov	r2, #0
	str	r2, [r3]
	ldrsh	r2, [fp, #-8]
	ldr	r1, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #24
	mov	r2, #0
	str	r2, [r3]
	ldrsh	r1, [fp, #-12]
	ldrsh	r2, [fp, #-8]
	ldr	r0, .CheckOppositeCarCollision+24
	mov	r3, r1
	lsl	r3, r3, #1
	add	r3, r3, r1
	lsl	r3, r3, #2
	add	r3, r0, r3
	ldrsh	r1, [r3]
	ldr	r0, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	strh	r1, [r3]	
	ldrsh	r1, [fp, #-12]
	ldrsh	r2, [fp, #-8]
	ldr	r0, .CheckOppositeCarCollision+24
	mov	r3, r1
	lsl	r3, r3, #1
	add	r3, r3, r1
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #2
	ldrsh	r1, [r3]
	ldr	r0, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #2
	strh	r1, [r3]	
	ldrsh	r2, [fp, #-12]
	ldr	r1, .CheckOppositeCarCollision+24
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #4
	ldrsh	r3, [r3]
	uxth	r2, r3
	ldrh	r3, [fp, #-22]
	add	r3, r2, r3
	ldrsh	r2, [fp, #-8]
	sxth	r1, r3
	ldr	r0, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #4
	strh	r1, [r3]	
	ldrsh	r1, [fp, #-12]
	ldrsh	r2, [fp, #-8]
	ldr	r0, .CheckOppositeCarCollision+24
	mov	r3, r1
	lsl	r3, r3, #1
	add	r3, r3, r1
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #6
	ldrsh	r1, [r3]
	ldr	r0, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #6
	strh	r1, [r3]	
	ldrsh	r1, [fp, #-12]
	ldrsh	r2, [fp, #-8]
	ldr	r0, .CheckOppositeCarCollision+24
	mov	r3, r1
	lsl	r3, r3, #1
	add	r3, r3, r1
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #8
	ldr	r1, [r3]
	ldr	r0, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #8
	str	r1, [r3]
	ldrsh	r2, [fp, #-8]
	ldr	r1, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #6
	ldrh	r3, [r3]	
	strh	r3, [fp, #-24]	
	ldrb	r3, [fp, #-13]
	cmp	r3, #2
	beq	.IncreaseOppositeCarSpeed
	cmp	r3, #2
	bgt	.UpdatePlayerCar
	cmp	r3, #0
	beq	.IncreaseOppositeCarSpeed2
	cmp	r3, #1
	beq	.DecreaseOppositeCarSpeed
	b	.UpdatePlayerCar
@ increase the opponent's car speed
.IncreaseOppositeCarSpeed:
	ldrh	r3, [fp, #-24]
	add	r3, r3, #10
	strh	r3, [fp, #-16]	
	b	.UpdatePlayerCar
@ decrease the opponent's car speed
.DecreaseOppositeCarSpeed:
	ldrh	r3, [fp, #-24]
	add	r3, r3, #36
	strh	r3, [fp, #-16]	
	b	.UpdatePlayerCar
@ increase the opponent's car speed
.IncreaseOppositeCarSpeed2:
	ldrh	r3, [fp, #-24]
	add	r3, r3, #62
	strh	r3, [fp, #-16]	
@ update the state of player's car
.UpdatePlayerCar:
	ldrsh	r2, [fp, #-8]
	ldr	r1, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #12
	ldrh	r2, [fp, #-16]	
	strh	r2, [r3]	
	ldrsh	r2, [fp, #-8]
	ldr	r1, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #2
	ldrsh	r3, [r3]
	rsb	r3, r3, #3
	ldrsh	r2, [fp, #-8]
	sxth	r1, r3
	ldr	r0, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #14
	strh	r1, [r3]	
	ldrsh	r2, [fp, #-8]
	ldr	r1, .CheckOppositeCarCollision
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #16
	ldrb	r2, [fp, #-13]
	strb	r2, [r3]
	ldrb	r3, [fp, #-13]
	sxth	r3, r3
	ldr	r2, .CheckOppositeCarCollision+8
	strh	r3, [r2]	
	b	.ReturnFromFunction2
.BranchToReturn2:
	b	.ReturnFromFunction2
.NoOperation3:	
	nop
.ReturnFromFunction2:
	sub	sp, fp, #4
	pop	{fp, pc}

@ ------------------ CAR COLLISION -------------------
.CheckOppositeCarCollision:
	.word	f1race_opposite_car
	.word	1431655766
	.word	f1race_last_car_road
	.word	-1431655765
	.word	f1race_level
	.word	780903145
	.word	f1race_opposite_car_type
	.size	F1Race_New_Opposite_Car, .-F1Race_New_Opposite_Car
	.align	2
	.type	F1Race_CollisionCheck, %function
@ function to check car collision
F1Race_CollisionCheck:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	ldr	r3, .F1Race_CollisionCheck
	ldrsh	r3, [r3]
	sub	r3, r3, #1
	strh	r3, [fp, #-8]	
	ldr	r3, .F1Race_CollisionCheck
	ldrsh	r3, [r3, #4]
	uxth	r2, r3
	ldrh	r3, [fp, #-8]
	add	r3, r2, r3
	sub	r3, r3, #1
	strh	r3, [fp, #-10]	
	ldr	r3, .F1Race_CollisionCheck
	ldrsh	r3, [r3, #2]
	sub	r3, r3, #1
	strh	r3, [fp, #-12]	
	ldr	r3, .F1Race_CollisionCheck
	ldrsh	r3, [r3, #6]
	uxth	r2, r3
	ldrh	r3, [fp, #-12]
	add	r3, r2, r3
	sub	r3, r3, #1
	strh	r3, [fp, #-14]	
	mov	r3, #0
	strh	r3, [fp, #-6]	
	b	.CheckValueAndBranch
@ update the value for checking collisions
.UpdateCollisionCheckValues_BasedOnConditions:
	ldrsh	r2, [fp, #-6]
	ldr	r1, .F1Race_CollisionCheck+4
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #20
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.IncrementValue
	ldrsh	r2, [fp, #-6]
	ldr	r1, .F1Race_CollisionCheck+4
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #12
	ldrsh	r3, [r3]
	sub	r3, r3, #1
	strh	r3, [fp, #-16]	
	ldrsh	r2, [fp, #-6]
	ldr	r1, .F1Race_CollisionCheck+4
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	ldrsh	r3, [r3]
	uxth	r2, r3
	ldrh	r3, [fp, #-16]
	add	r3, r2, r3
	sub	r3, r3, #1
	strh	r3, [fp, #-18]	
	ldrsh	r2, [fp, #-6]
	ldr	r1, .F1Race_CollisionCheck+4
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #14
	ldrsh	r3, [r3]
	sub	r3, r3, #1
	strh	r3, [fp, #-20]	
	ldrsh	r2, [fp, #-6]
	ldr	r1, .F1Race_CollisionCheck+4
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #2
	ldrsh	r3, [r3]
	uxth	r2, r3
	ldrh	r3, [fp, #-20]
	add	r3, r2, r3
	sub	r3, r3, #1
	strh	r3, [fp, #-22]	
	ldrsh	r2, [fp, #-8]
	ldrsh	r3, [fp, #-16]
	cmp	r2, r3
	bgt	.F1Race_CheckCollisions
	ldrsh	r2, [fp, #-16]
	ldrsh	r3, [fp, #-10]
	cmp	r2, r3
	ble	.F1Race_CollisionChecking4

.F1Race_CheckCollisions:
	ldrsh	r2, [fp, #-8]
	ldrsh	r3, [fp, #-18]
	cmp	r2, r3
	bgt	.F1Race_CollisionChecking2
	ldrsh	r2, [fp, #-18]
	ldrsh	r3, [fp, #-10]
	cmp	r2, r3
	bgt	.F1Race_CollisionChecking2
.F1Race_CollisionChecking4:
	ldrsh	r2, [fp, #-12]
	ldrsh	r3, [fp, #-20]
	cmp	r2, r3
	bgt	.F1Race_CollisionChecking3
	ldrsh	r2, [fp, #-20]
	ldrsh	r3, [fp, #-14]
	cmp	r2, r3
	ble	.F1Race_CollisionHandling
.F1Race_CollisionChecking3:
	ldrsh	r2, [fp, #-12]
	ldrsh	r3, [fp, #-22]
	cmp	r2, r3
	bgt	.F1Race_CollisionChecking2
	ldrsh	r2, [fp, #-22]
	ldrsh	r3, [fp, #-14]
	cmp	r2, r3
	bgt	.F1Race_CollisionChecking2
.F1Race_CollisionHandling:
	bl	F1Race_Crashing
	b	.FunctionCleanUp
.F1Race_CollisionChecking2:
	ldrsh	r2, [fp, #-8]
	ldrsh	r3, [fp, #-16]
	cmp	r2, r3
	blt	.F1Race_CollisionChecking
	ldrsh	r2, [fp, #-8]
	ldrsh	r3, [fp, #-18]
	cmp	r2, r3
	bgt	.F1Race_CollisionChecking
	ldrsh	r2, [fp, #-12]
	ldrsh	r3, [fp, #-20]
	cmp	r2, r3
	blt	.F1Race_CollisionChecking
	ldrsh	r2, [fp, #-12]
	ldrsh	r3, [fp, #-22]
	cmp	r2, r3
	bgt	.F1Race_CollisionChecking
	bl	F1Race_Crashing
	b	.FunctionCleanUp
.F1Race_CollisionChecking:
	ldrsh	r2, [fp, #-8]
	ldrsh	r3, [fp, #-16]
	cmp	r2, r3
	blt	.CollisionHandling
	ldrsh	r2, [fp, #-8]
	ldrsh	r3, [fp, #-18]
	cmp	r2, r3	
	bgt	.CollisionHandling
	ldrsh	r2, [fp, #-14]
	ldrsh	r3, [fp, #-20]
	cmp	r2, r3
	blt	.CollisionHandling
	ldrsh	r2, [fp, #-14]
	ldrsh	r3, [fp, #-22]
	cmp	r2, r3
	bgt	.CollisionHandling
	bl	F1Race_Crashing
	b	.FunctionCleanUp
.CollisionHandling:
	ldrsh	r2, [fp, #-10]
	ldrsh	r3, [fp, #-16]
	cmp	r2, r3
	blt	.CollisionDetection
	ldrsh	r2, [fp, #-10]
	ldrsh	r3, [fp, #-18]
	cmp	r2, r3
	bgt	.CollisionDetection
	ldrsh	r2, [fp, #-12]
	ldrsh	r3, [fp, #-20]
	cmp	r2, r3
	blt	.CollisionDetection
	ldrsh	r2, [fp, #-12]
	ldrsh	r3, [fp, #-22]
	cmp	r2, r3
	bgt	.CollisionDetection
	bl	F1Race_Crashing
	b	.FunctionCleanUp
.CollisionDetection:
	ldrsh	r2, [fp, #-10]
	ldrsh	r3, [fp, #-16]
	cmp	r2, r3
	blt	.CollisionCheckingAndUpdatingHandling
	ldrsh	r2, [fp, #-10]
	ldrsh	r3, [fp, #-18]
	cmp	r2, r3
	bgt	.CollisionCheckingAndUpdatingHandling
	ldrsh	r2, [fp, #-14]
	ldrsh	r3, [fp, #-20]
	cmp	r2, r3
	blt	.CollisionCheckingAndUpdatingHandling
	ldrsh	r2, [fp, #-14]
	ldrsh	r3, [fp, #-22]
	cmp	r2, r3
	bgt	.CollisionCheckingAndUpdatingHandling
	bl	F1Race_Crashing
	b	.FunctionCleanUp
.CollisionCheckingAndUpdatingHandling:
	ldrsh	r2, [fp, #-14]
	ldrsh	r3, [fp, #-20]
	cmp	r2, r3
	bge	.IncrementValue
	ldrsh	r2, [fp, #-6]
	ldr	r1, .F1Race_CollisionCheck+4
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #24
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.IncrementValue
	ldr	r3, .F1Race_CollisionCheck+8
	ldrsh	r3, [r3]
	add	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1Race_CollisionCheck+8
	strh	r3, [r2]	
	ldr	r3, .F1Race_CollisionCheck+12
	ldrsh	r3, [r3]
	add	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1Race_CollisionCheck+12
	strh	r3, [r2]	
	ldrsh	r2, [fp, #-6]
	ldr	r1, .F1Race_CollisionCheck+4
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #24
	mov	r2, #1
	str	r2, [r3]
	ldr	r3, .F1Race_CollisionCheck+12
	ldrsh	r3, [r3]
	cmp	r3, #10
	bne	.CheckAndUpdateCollisionCount7
	ldr	r3, .F1Race_CollisionCheck+16
	ldrsh	r3, [r3]
	add	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1Race_CollisionCheck+16
	strh	r3, [r2]	
	b	.UpdateCollisionCheckValues
.CheckAndUpdateCollisionCount7:
	ldr	r3, .F1Race_CollisionCheck+12
	ldrsh	r3, [r3]
	cmp	r3, #20 @ mem locate 20
	bne	.CheckAndUpdateCollisionCount6
	ldr	r3, .F1Race_CollisionCheck+16
	ldrsh	r3, [r3]
	add	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1Race_CollisionCheck+16
	strh	r3, [r2]	
	b	.UpdateCollisionCheckValues
.CheckAndUpdateCollisionCount6:
	ldr	r3, .F1Race_CollisionCheck+12
	ldrsh	r3, [r3]
	cmp	r3, #30 @ mem locate 30
	bne	.CheckAndUpdateCollisionCount5
	ldr	r3, .F1Race_CollisionCheck+16
	ldrsh	r3, [r3]
	add	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1Race_CollisionCheck+16
	strh	r3, [r2]	
	b	.UpdateCollisionCheckValues
.CheckAndUpdateCollisionCount5:
	ldr	r3, .F1Race_CollisionCheck+12
	ldrsh	r3, [r3]
	cmp	r3, #40 @ mem locate 40
	bne	.CheckAndUpdateCollisionCount4
	ldr	r3, .F1Race_CollisionCheck+16
	ldrsh	r3, [r3]
	add	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1Race_CollisionCheck+16
	strh	r3, [r2]	
	b	.UpdateCollisionCheckValues
.CheckAndUpdateCollisionCount4:
	ldr	r3, .F1Race_CollisionCheck+12
	ldrsh	r3, [r3]
	cmp	r3, #50 @ mem locate 50
	bne	.CheckAndUpdateCollisionCount3
	ldr	r3, .F1Race_CollisionCheck+16
	ldrsh	r3, [r3]
	add	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1Race_CollisionCheck+16
	strh	r3, [r2]	
	b	.UpdateCollisionCheckValues
.CheckAndUpdateCollisionCount3:
	ldr	r3, .F1Race_CollisionCheck+12
	ldrsh	r3, [r3]
	cmp	r3, #60 @ mem locate 60
	bne	.CheckAndUpdateCollisionCount2
	ldr	r3, .F1Race_CollisionCheck+16
	ldrsh	r3, [r3]
	add	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1Race_CollisionCheck+16
	strh	r3, [r2]	
	b	.UpdateCollisionCheckValues
.CheckAndUpdateCollisionCount2:
	ldr	r3, .F1Race_CollisionCheck+12
	ldrsh	r3, [r3]
	cmp	r3, #70 @ mem locate 70
	bne	.CheckAndUpdateCollisionCount
	ldr	r3, .F1Race_CollisionCheck+16
	ldrsh	r3, [r3]
	add	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1Race_CollisionCheck+16
	strh	r3, [r2]	
	b	.UpdateCollisionCheckValues
.CheckAndUpdateCollisionCount:
	ldr	r3, .F1Race_CollisionCheck+12
	ldrsh	r3, [r3]
	cmp	r3, #100 @ mem locate 100
	bne	.UpdateCollisionCheckValues
	ldr	r3, .F1Race_CollisionCheck+16
	ldrsh	r3, [r3]
	add	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1Race_CollisionCheck+16
	strh	r3, [r2]	
.UpdateCollisionCheckValues:
	ldr	r3, .F1Race_CollisionCheck+20
	ldrsh	r3, [r3]
	add	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1Race_CollisionCheck+20
	strh	r3, [r2]	
	ldr	r3, .F1Race_CollisionCheck+20
	ldrsh	r3, [r3]
	cmp	r3, #5
	ble	.IncrementValue
	ldr	r3, .F1Race_CollisionCheck+24
	ldrsh	r3, [r3]
	cmp	r3, #8
	bgt	.DecrementCollisionCheckValue
	ldr	r3, .F1Race_CollisionCheck+20
	mov	r2, #0
	strh	r2, [r3]	
	ldr	r3, .F1Race_CollisionCheck+24
	ldrsh	r3, [r3]
	add	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1Race_CollisionCheck+24
	strh	r3, [r2]	
	b	.IncrementValue
.DecrementCollisionCheckValue:
	ldr	r3, .F1Race_CollisionCheck+20
	ldrsh	r3, [r3]
	sub	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1Race_CollisionCheck+20
	strh	r3, [r2]	
.IncrementValue:
	ldrsh	r3, [fp, #-6]
	add	r3, r3, #1
	strh	r3, [fp, #-6]	
.CheckValueAndBranch:
	ldrsh	r3, [fp, #-6]
	cmp	r3, #7
	ble	.UpdateCollisionCheckValues_BasedOnConditions
@ function used for cleanup, used at the end of functions
.FunctionCleanUp:
	sub	sp, fp, #4
	pop	{fp, pc}
.F1Race_CollisionCheck:
	.word	f1race_player_car
	.word	f1race_opposite_car
	.word	f1race_score
	.word	f1race_pass
	.word	f1race_level
	.word	f1race_fly_charger_count
	.word	f1race_fly_count
	.size	F1Race_CollisionCheck, .-F1Race_CollisionCheck
	.align	2
	.type	F1Race_Framemove, %function

@ ----------------------- FRAMEMOVE -----------------------
F1Race_Framemove:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	ldr	r3, .F1Race_Framemove
	ldrsh	r3, [r3]
	add	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1Race_Framemove
	strh	r3, [r2]	
	ldr	r3, .F1Race_Framemove
	ldrsh	r3, [r3]
	cmp	r3, #10
	bne	.CheckFrameMove4
	ldr	r3, .F1Race_Framemove+4
	mov	r2, #0
	str	r2, [r3]
.CheckFrameMove4:
	mov	r3, #5
	strh	r3, [fp, #-6]	
	ldr	r3, .F1Race_Framemove+8
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.CheckFrameMove2
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3, #2]
	mov	r2, r3
	ldrsh	r3, [fp, #-6]
	sub	r3, r2, r3
	cmp	r3, #2
	bgt	.CheckFrameMove3
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3, #2]
	sub	r3, r3, #4
	strh	r3, [fp, #-6]	
.CheckFrameMove3:
	ldr	r3, .F1Race_Framemove+4
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.CheckFrameMove2
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3, #2]
	uxth	r2, r3
	ldrh	r3, [fp, #-6]
	sub	r3, r2, r3
	sxth	r3, r3
	ldr	r2, .F1Race_Framemove+12
	strh	r3, [r2, #2]	
.CheckFrameMove2:
	ldr	r3, .F1Race_Framemove+16
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.UpdateFrameMove
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3, #2]
	uxth	r2, r3
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3, #6]
	add	r3, r2, r3
	strh	r3, [fp, #-10]	
	ldrsh	r2, [fp, #-10]
	ldrsh	r3, [fp, #-6]
	add	r3, r2, r3
	cmp	r3, #124
	ble	.CheckFrameMove
	ldrh	r3, [fp, #-10]
	rsb	r3, r3, #124
	strh	r3, [fp, #-6]	
.CheckFrameMove:
	ldr	r3, .F1Race_Framemove+4
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.UpdateFrameMove
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3, #2]
	uxth	r2, r3
	ldrh	r3, [fp, #-6]
	add	r3, r2, r3
	sxth	r3, r3
	ldr	r2, .F1Race_Framemove+12
	strh	r3, [r2, #2]	
.UpdateFrameMove:
	ldr	r3, .F1Race_Framemove+20
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.HandleOppositeCarCollision
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3]
	uxth	r2, r3
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3, #4]
	add	r3, r2, r3
	strh	r3, [fp, #-10]	
	ldrsh	r2, [fp, #-10]
	ldrsh	r3, [fp, #-6]
	add	r3, r2, r3
	cmp	r3, #84
	ble	.UpdateCarPositionValue
	ldrh	r3, [fp, #-10]
	rsb	r3, r3, #84
	strh	r3, [fp, #-6]
@ update the player's car position 
.UpdateCarPositionValue:
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3]
	uxth	r2, r3
	ldrh	r3, [fp, #-6]
	add	r3, r2, r3
	sxth	r3, r3
	ldr	r2, .F1Race_Framemove+12
	strh	r3, [r2]
@ haddle oppeosite car if it's collided	
.HandleOppositeCarCollision:
	ldr	r3, .F1Race_Framemove+24
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.ResetCarCollision
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3]
	mov	r2, r3
	ldrsh	r3, [fp, #-6]
	sub	r3, r2, r3
	cmp	r3, #9	
	bgt	.AdjustOppositeCarPosition
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3]
	sub	r3, r3, #11
	strh	r3, [fp, #-6]	
@ adjusts the position of an opposite car based on values in memory
.AdjustOppositeCarPosition:
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3]
	uxth	r2, r3
	ldrh	r3, [fp, #-6]
	sub	r3, r2, r3
	sxth	r3, r3
	ldr	r2, .F1Race_Framemove+12
	strh	r3, [r2]
@ reset the cllision of an opposite car based on values in memory	
.ResetCarCollision:
	mov	r3, #0
	strh	r3, [fp, #-8]	
	b	.CollisionAndOppositeDecision
@ update car's position based on the frames
.CarPositionUpdate:
	ldrsh	r2, [fp, #-8]
	ldr	r1, .F1Race_Framemove+28
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #20
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.UpdatePlayerCarPosition
	ldrsh	r2, [fp, #-8]
	ldr	r1, .F1Race_Framemove+28
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #14
	ldrsh	r3, [r3]
	uxth	r1, r3
	ldrsh	r2, [fp, #-8]
	ldr	r0, .F1Race_Framemove+28
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #4
	ldrsh	r3, [r3]
	add	r3, r1, r3
	ldrsh	r2, [fp, #-8]
	sxth	r1, r3
	ldr	r0, .F1Race_Framemove+28
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #14
	strh	r1, [r3]	
	ldrsh	r2, [fp, #-8]
	ldr	r1, .F1Race_Framemove+28
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #14
	ldrsh	r3, [r3]
	mov	r0, r3
	ldrsh	r2, [fp, #-8]
	ldr	r1, .F1Race_Framemove+28
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #2
	ldrsh	r3, [r3]
	add	r3, r3, #124
	cmp	r0, r3
	ble	.UpdatePlayerCarPosition
	ldrsh	r2, [fp, #-8]
	ldr	r1, .F1Race_Framemove+28
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #20
	mov	r2, #1
	str	r2, [r3]
@ update the player's car position
.UpdatePlayerCarPosition:
	ldrsh	r3, [fp, #-8]
	add	r3, r3, #1
	strh	r3, [fp, #-8]	
@ handle collisions and the positioning of cars.
.CollisionAndOppositeDecision:
	ldrsh	r3, [fp, #-8]
	cmp	r3, #7
	ble	.CarPositionUpdate
	ldr	r3, .F1Race_Framemove+4
	ldr	r3, [r3]	
	cmp	r3, #0
	beq	.F1Race_HandleCollisionAndOppositeCar
	mov	r3, #2
	strh	r3, [fp, #-6]	
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3, #2]
	mov	r2, r3
	ldrsh	r3, [fp, #-6]
	sub	r3, r2, r3
	cmp	r3, #2
	bgt	.F1Race_AdjustCarPosition
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3, #2]
	sub	r3, r3, #4
	strh	r3, [fp, #-6]
@Adjust Player Car Position	
.F1Race_AdjustCarPosition:
	ldr	r3, .F1Race_Framemove+12
	ldrsh	r3, [r3, #2]
	uxth	r2, r3
	ldrh	r3, [fp, #-6]
	sub	r3, r2, r3
	sxth	r3, r3
	ldr	r2, .F1Race_Framemove+12
	strh	r3, [r2, #2]	
	b	.F1Race_ContinueOrExit
@branch to check collision
.F1Race_HandleCollisionAndOppositeCar:
	bl	F1Race_CollisionCheck
	
.F1Race_ContinueOrExit:
	bl	F1Race_New_Opposite_Car
	sub	sp, fp, #4
	pop	{fp, pc}
.F1Race_Framemove:
	.word	f1race_player_car_fly_duration
	.word	f1race_player_is_car_fly
	.word	f1race_key_up_pressed
	.word	f1race_player_car
	.word	f1race_key_down_pressed
	.word	f1race_key_right_pressed
	.word	f1race_key_pressed
	.word	f1race_opposite_car
	.size	F1Race_Framemove, .-F1Race_Framemove
	.align	2
	.type	F1Race_Cyclic_Timer, %function
F1Race_Cyclic_Timer:
	push	{fp, lr}
	add	fp, sp, #4
	ldr	r3, .F1_gameLoop
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.Decrement_game_loop_counter
	bl	F1Race_Framemove
	bl	F1Race_Render
	b	.ReturnFromFunction
@ control the progression of the game loop, handling game events, rendering, and sound effects values
.Decrement_game_loop_counter:
	ldr	r3, .F1_gameLoop+4
	ldrsh	r3, [r3]
	sub	r3, r3, #1
	sxth	r3, r3
	ldr	r2, .F1_gameLoop+4
	strh	r3, [r2]	
	ldr	r3, .F1_gameLoop+4
	ldrsh	r3, [r3]
	cmp	r3, #39
	ble	.PlayBackgroundMusic
	bl	F1Race_Render_Player_Car_Crash
	b	.CheckGameLoopCondition
@ handle music for gameover screen
.PlayBackgroundMusic:
	ldr	r3, .F1_gameLoop+4
	ldrsh	r3, [r3]
	cmp	r3, #39
	bne	.ShowGameOverScreen
	mov	r1, #0
	mov	r0, #3
	bl	Music_Play
@ branch to gameover screen
.ShowGameOverScreen:
	bl	F1Race_Show_Game_Over_Screen
@ checking the game loop condition and initializing variables before executing the main game logic
.CheckGameLoopCondition:
	ldr	r3, .F1_gameLoop+4
	ldrsh	r3, [r3]
	cmp	r3, #0
	bgt	.ReturnFromFunction
	ldr	r3, .F1_gameLoop
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, .F1_gameLoop+8
	mov	r2, #1
	str	r2, [r3]
	bl	F1Race_Main
.ReturnFromFunction:
	pop	{fp, pc}
.F1_gameLoop:
	.word	f1race_is_crashing
	.word	f1race_crashing_count_down
	.word	f1race_is_new_game
	.size	F1Race_Cyclic_Timer, .-F1Race_Cyclic_Timer
	.align	2
	.type	main_loop, %function
main_loop:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #80
	str	r0, [fp, #-80]
	b	.renderingAndEventLoop
@ acts as a dispatcher that routes different events or actions based on the value in register
.EventHandling:
	ldr	r3, [fp, #-60]
	ldr	r2, .renderLoop
	cmp	r3, r2
	beq	.HandleKeyboardKeyRelease
	ldr	r2, .renderLoop
	cmp	r3, r2
	bhi	.renderingAndEventLoop
	cmp	r3, #256
	beq	.InitializeRender
	cmp	r3, #768
	beq	.HandleKeyboardKeyPress
	b	.renderingAndEventLoop
@ perform an initialization step to signal that rendering should begin
.InitializeRender:
	ldr	r3, .renderLoop+4
	mov	r2, #1
	str	r2, [r3]
	b	.renderingAndEventLoop

@ handling keyboard key press and key release event
.HandleKeyboardKeyPress:
	ldr	r3, [fp, #-40]
	mov	r1, #1
	mov	r0, r3
	bl	F1Race_Keyboard_Key_Handler
	b	.renderingAndEventLoop
.HandleKeyboardKeyRelease:
	ldr	r3, [fp, #-40]
	mov	r1, #0
	mov	r0, r3
	bl	F1Race_Keyboard_Key_Handler

@ responsible for rendering and event processing
.renderingAndEventLoop:
	sub	r3, fp, #60  @ address for stack frame rate at an offset of 60 bytes from the frame pointer and stores in r3
	mov	r0, r3
	bl	SDL_PollEvent
	mov	r3, r0
	cmp	r3, #0
	bne	.EventHandling
	ldr	r3, .renderLoop+8
	ldr	r3, [r3]
	ldr	r1, [fp, #-80]
	mov	r0, r3
	bl	SDL_SetRenderTarget
	bl	F1Race_Cyclic_Timer
	ldr	r3, .renderLoop+8
	ldr	r3, [r3]
	mov	r1, #0
	mov	r0, r3
	bl	SDL_SetRenderTarget
	mov	r3, #0
	str	r3, [fp, #-76]
	mov	r3, #0
	str	r3, [fp, #-72]
	mov	r3, #512
	str	r3, [fp, #-68]
	mov	r3, #512
	str	r3, [fp, #-64]
	ldr	r3, .renderLoop+8
	ldr	r0, [r3]
	sub	r2, fp, #76
	mov	r3, #0
	ldr	r1, [fp, #-80]
	bl	SDL_RenderCopy
	ldr	r3, .renderLoop+8
	ldr	r3, [r3]
	mov	r0, r3
	bl	SDL_RenderPresent
	sub	sp, fp, #4
	pop	{fp, pc}
@ defines the renderLoop with associated data and labels
.renderLoop:
	.word	769
	.word	exit_main_loop
	.word	render
	.size	main_loop, .-main_loop
	.section	.rodata
	.align	2
@ stores an error message for SDL initialization
.SDL_Init_Error:
	.ascii	"SDL_Init Error: %s.\012\000"
	.align	2
@ related to a rendering quality setting
.Nearest:
	.ascii	"nearest\000"
	.align	2
@ related to a rendering quality setting
.RenderScaleQuality:
	.ascii	"SDL_RENDER_SCALE_QUALITY\000"
	.align	2
@ stores the title of the game ('F1 Race')
.GameTitle:
	.ascii	"F1 Race\000"
	.align	2
@ stores an error message for SDL window creation
.SDLCreateWindowErrorString:
	.ascii	"SDL_CreateWindow Error: %s.\012\000"
	.align	2
@ stores the path to the game's icon image
.F1RaceIconPath:
	.ascii	"assets/GAME_F1RACE_ICON.bmp\000"
	.align	2
@ stores an error message for SDL BMP loading
.SDLLoadBMPErrorString:
	.ascii	"SDL_LoadBMP Error: %s.\012\000"
	.align	2
@ stores an error message for SDL renderer creation.
.SDLCreateRendererErrorString:
	.ascii	"SDL_CreateRenderer Error: %s.\012\000"
	.align	2
@ stores an error message for Mix_Init
.MixInitErrorString:
	.ascii	"Mix_Init Error: %s.\012\000"
	.align	2
@ stores an error message for Mix_OpenAudio
.MixOpenAudioErrorString:
	.ascii	"Mix_OpenAudio Error: %s.\012\000"
	.text
	.align	2
	.global	main
	.type	main, %function
	
@ checks for initialization errors, and proceeds with cleanup if an error is encountered.
main:
	push	{r4, fp, lr}
	add	fp, sp, #8
	sub	sp, sp, #36
	str	r0, [fp, #-32]
	str	r1, [fp, #-36]
	mov	r0, #0
	bl	time
	mov	r3, r0
	mov	r0, r3
	bl	srand
	mov	r0, #48
	bl	SDL_Init
	mov	r3, r0
	cmp	r3, #0
	beq	.CreateWindowOrCleanup
	ldr	r3, .var_data
	ldr	r4, [r3]
	bl	SDL_GetError
	mov	r3, r0
	mov	r2, r3
	ldr	r1, .var_data+4
	mov	r0, r4
	bl	fprintf
	mov	r3, #1
	b	.cleanup
@ initializing a window and handling potential errors during the process.
.CreateWindowOrCleanup:
	ldr	r1, .var_data+8
	ldr	r0, .var_data+12
	bl	SDL_SetHint
	mov	r3, #36
	str	r3, [sp, #4]
	mov	r3, #512
	str	r3, [sp]
	mov	r3, #512
	ldr	r2, .var_data+16
	ldr	r1, .var_data+16
	ldr	r0, .var_data+20
	bl	SDL_CreateWindow
	str	r0, [fp, #-16]
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	bne	.LoadIconOrCleanup
	ldr	r3, .var_data
	ldr	r4, [r3]
	bl	SDL_GetError
	mov	r3, r0
	mov	r2, r3
	ldr	r1, .var_data+24
	mov	r0, r4
	bl	fprintf
	mov	r3, #1
	b	.cleanup
@ Download Icon if not Clean
.LoadIconOrCleanup:
	ldr	r1, .var_data+28
	ldr	r0, .var_data+32
	bl	SDL_RWFromFile
	mov	r3, r0
	mov	r1, #1
	mov	r0, r3
	bl	SDL_LoadBMP_RW
	str	r0, [fp, #-20]
	ldr	r3, [fp, #-20]
	cmp	r3, #0
	bne	.SetWindowIconAndCleanup
	ldr	r3, .var_data
	ldr	r4, [r3]
	bl	SDL_GetError
	mov	r3, r0
	mov	r2, r3
	ldr	r1, .var_data+36
	mov	r0, r4
	bl	fprintf
	b	.RendererCreationAndCleanup
@sets a window icon, applies color key transparency, and frees an SDL surface.
.SetWindowIconAndCleanup:
	ldr	r3, [fp, #-20]
	ldr	r0, [r3, #4]
	mov	r3, #113
	mov	r2, #227
	mov	r1, #36
	bl	SDL_MapRGB
	mov	r3, r0
	mov	r2, r3
	mov	r1, #1
	ldr	r0, [fp, #-20]
	bl	SDL_SetColorKey
	ldr	r1, [fp, #-20]
	ldr	r0, [fp, #-16]
	bl	SDL_SetWindowIcon
	ldr	r0, [fp, #-20]
	bl	SDL_FreeSurface
@ creates a renderer for graphics, checks for errors during renderer creation, and handles errors by printing an error message and performing cleanup
.RendererCreationAndCleanup:
	mov	r2, #10
	mvn	r1, #0
	ldr	r0, [fp, #-16]
	bl	SDL_CreateRenderer
	mov	r3, r0
	ldr	r2, .var_data+40
	str	r3, [r2]
	ldr	r3, .var_data+40
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.TextureAndAudioInitialization
	ldr	r3, .var_data
	ldr	r4, [r3]
	bl	SDL_GetError
	mov	r3, r0
	mov	r2, r3
	ldr	r1, .var_data+44
	mov	r0, r4
	bl	fprintf
	ldr	r0, [fp, #-16]
	bl	SDL_DestroyWindow
	bl	SDL_Quit
	mov	r3, #1
	b	.cleanup
@ initializes textures and audio, checks for errors during initialization, and handles errors by printing an error message
.TextureAndAudioInitialization:
	bl	Texture_Load
	mov	r0, #16
	bl	Mix_Init
	str	r0, [fp, #-24]
	ldr	r3, [fp, #-24]
	cmp	r3, #16
	beq	.AudioInitialization
	ldr	r3, .var_data
	ldr	r4, [r3]
	bl	SDL_GetError
	mov	r3, r0
	mov	r2, r3
	ldr	r1, .var_data+48
	mov	r0, r4
	bl	fprintf
	mov	r3, #1
	b	.cleanup
@initializes audio, checks for errors during audio initialization, and if an error is detected, it prints an error message
.AudioInitialization:
	mov	r3, #4096
	mov	r2, #1
	ldr	r1, .var_data+52
	ldr	r0, .var_data+56
	bl	Mix_OpenAudio
	mov	r3, r0
	cmn	r3, #1
	bne	.AudioPlaybackAndGameInitialization
	ldr	r3, .var_data
	ldr	r4, [r3]
	bl	SDL_GetError
	mov	r3, r0
	mov	r2, r3
	ldr	r1, .var_data+60
	mov	r0, r4
	bl	fprintf
	mov	r3, #1
	b	.cleanup
@initializes audio, sets render targets using SDL, and likely runs the main game logic with "F1Race_Main."
.AudioPlaybackAndGameInitialization:
	bl	Music_Load
	ldr	r3, .var_data+40
	ldr	r3, [r3]
	ldr	r2, .var_data+64
	ldr	r2, [r2, #40]
	mov	r1, r2
	mov	r0, r3
	bl	SDL_SetRenderTarget
	ldr	r3, .var_data+40
	ldr	r3, [r3]
	mov	r0, r3
	bl	SDL_RenderClear
	bl	F1Race_Main
	ldr	r3, .var_data+40
	ldr	r3, [r3]
	mov	r1, #0
	mov	r0, r3
	bl	SDL_SetRenderTarget
	b	.GameCleanup
@start looping gameplay
.MainLoopStart:
	ldr	r3, .var_data+64
	ldr	r3, [r3, #40]
	mov	r0, r3
	bl	main_loop
	mov	r0, #100
	bl	SDL_Delay
@ clean up and closing game 
.GameCleanup:
	ldr	r3, .var_data+68
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.MainLoopStart
	bl	Mix_CloseAudio
	bl	Music_Unload
	bl	Texture_Unload
	ldr	r3, .var_data+40
	ldr	r3, [r3]
	mov	r0, r3
	bl	SDL_DestroyRenderer
	ldr	r0, [fp, #-16]
	bl	SDL_DestroyWindow
	bl	SDL_Quit
	mov	r3, #0
@ cleaning up the stack frame and resoring registers
.cleanup:
	mov	r0, r3
	sub	sp, fp, #8
	pop	{r4, fp, pc}
@ initializes data parameters
.var_data:
	.word	stderr
	.word	.SDL_Init_Error
	.word	.Nearest
	.word	.RenderScaleQuality
	.word	536805376
	.word	.GameTitle
	.word	.SDLCreateWindowErrorString
	.word	.TextureCreateBitmap
	.word	.F1RaceIconPath
	.word	.SDLLoadBMPErrorString
	.word	render
	.word	.SDLCreateRendererErrorString
	.word	.MixInitErrorString
	.word	32784
	.word	44100
	.word	.MixOpenAudioErrorString
	.word	textures
	.word	exit_main_loop
	.size	main, .-main
	
#include "F1_Race.h"

static void Music_Load(void) { //load music with SDL_mixer built-in method for each section (background, crash, game end)
	music_tracks[MUSIC_BACKGROUND] = Mix_LoadMUS("assets/GAME_F1RACE_BGM.ogg");
	music_tracks[MUSIC_BACKGROUND_LOWCOST] = Mix_LoadMUS("assets/GAME_F1RACE_BGM1.ogg");
	music_tracks[MUSIC_CRASH] = Mix_LoadMUS("assets/GAME_F1RACE_CRASH.ogg");
	music_tracks[MUSIC_GAMEOVER] = Mix_LoadMUS("assets/GAME_F1RACE_GAMEOVER.ogg");
}

static void Music_Play(MUSIC_TRACK track, Sint32 loop) { // recall the Mix_PlayMusic function to play the soundtrack
	Mix_PlayMusic(music_tracks[track], loop);
}

static void Music_Unload(void) { // unload the music loaded to free up the memory to ensure efficient memory management
	int i = 0;
	for (; i < MUSIC_MAX; ++i)
		if (music_tracks[i])
			Mix_FreeMusic(music_tracks[i]);
}

static void Texture_Create_Bitmap(const char *filepath, TEXTURE texture_id) // Loading bitmap image file, creating an SDL texture from that image.
{
	SDL_Surface *bitmap = SDL_LoadBMP(filepath);
	textures[texture_id] = SDL_CreateTextureFromSurface(render, bitmap);
	SDL_FreeSurface(bitmap);
}

static void Texture_Load(void) //load the hand-drawn pixel sprite
{
	textures[TEXTURE_SCREEN] =
		SDL_CreateTexture(render, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_TARGET, TEXTURE_WIDTH, TEXTURE_HEIGHT);

	Texture_Create_Bitmap("assets/GAME_F1RACE_NUMBER_0.bmp", TEXTURE_NUMBER_0);
	Texture_Create_Bitmap("assets/GAME_F1RACE_NUMBER_1.bmp", TEXTURE_NUMBER_1);
	Texture_Create_Bitmap("assets/GAME_F1RACE_NUMBER_2.bmp", TEXTURE_NUMBER_2);
	Texture_Create_Bitmap("assets/GAME_F1RACE_NUMBER_3.bmp", TEXTURE_NUMBER_3);
	Texture_Create_Bitmap("assets/GAME_F1RACE_NUMBER_4.bmp", TEXTURE_NUMBER_4);
	Texture_Create_Bitmap("assets/GAME_F1RACE_NUMBER_5.bmp", TEXTURE_NUMBER_5);
	Texture_Create_Bitmap("assets/GAME_F1RACE_NUMBER_6.bmp", TEXTURE_NUMBER_6);
	Texture_Create_Bitmap("assets/GAME_F1RACE_NUMBER_7.bmp", TEXTURE_NUMBER_7);
	Texture_Create_Bitmap("assets/GAME_F1RACE_NUMBER_8.bmp", TEXTURE_NUMBER_8);
	Texture_Create_Bitmap("assets/GAME_F1RACE_NUMBER_9.bmp", TEXTURE_NUMBER_9);
	Texture_Create_Bitmap("assets/GAME_F1RACE_PLAYER_CAR.bmp", TEXTURE_PLAYER_CAR);
	Texture_Create_Bitmap("assets/GAME_F1RACE_PLAYER_CAR_FLY.bmp", TEXTURE_PLAYER_CAR_FLY);
	Texture_Create_Bitmap("assets/GAME_F1RACE_PLAYER_CAR_FLY_UP.bmp", TEXTURE_PLAYER_CAR_FLY_UP);
	Texture_Create_Bitmap("assets/GAME_F1RACE_PLAYER_CAR_FLY_DOWN.bmp", TEXTURE_PLAYER_CAR_FLY_DOWN);
	Texture_Create_Bitmap("assets/GAME_F1RACE_PLAYER_CAR_HEAD_LIGHT.bmp", TEXTURE_PLAYER_CAR_HEAD_LIGHT);
	Texture_Create_Bitmap("assets/GAME_F1RACE_PLAYER_CAR_CRASH.bmp", TEXTURE_PLAYER_CAR_CRASH);
	Texture_Create_Bitmap("assets/GAME_F1RACE_LOGO.bmp", TEXTURE_LOGO);
	Texture_Create_Bitmap("assets/GAME_F1RACE_STATUS_SCORE.bmp", TEXTURE_STATUS_SCORE);
	Texture_Create_Bitmap("assets/GAME_F1RACE_STATUS_BOX.bmp", TEXTURE_STATUS_BOX);
	Texture_Create_Bitmap("assets/GAME_F1RACE_STATUS_LEVEL.bmp", TEXTURE_STATUS_LEVEL);
	Texture_Create_Bitmap("assets/GAME_F1RACE_STATUS_FLY.bmp", TEXTURE_STATUS_FLY);
	Texture_Create_Bitmap("assets/GAME_F1RACE_OPPOSITE_CAR_0.bmp", TEXTURE_OPPOSITE_CAR_0);
	Texture_Create_Bitmap("assets/GAME_F1RACE_OPPOSITE_CAR_1.bmp", TEXTURE_OPPOSITE_CAR_1);
	Texture_Create_Bitmap("assets/GAME_F1RACE_OPPOSITE_CAR_2.bmp", TEXTURE_OPPOSITE_CAR_2);
	Texture_Create_Bitmap("assets/GAME_F1RACE_OPPOSITE_CAR_3.bmp", TEXTURE_OPPOSITE_CAR_3);
	Texture_Create_Bitmap("assets/GAME_F1RACE_OPPOSITE_CAR_4.bmp", TEXTURE_OPPOSITE_CAR_4);
	Texture_Create_Bitmap("assets/GAME_F1RACE_OPPOSITE_CAR_5.bmp", TEXTURE_OPPOSITE_CAR_5);
	Texture_Create_Bitmap("assets/GAME_F1RACE_OPPOSITE_CAR_6.bmp", TEXTURE_OPPOSITE_CAR_6);
	Texture_Create_Bitmap("assets/GAME_F1RACE_GAMEOVER.bmp", TEXTURE_GAMEOVER);
	Texture_Create_Bitmap("assets/GAME_F1RACE_GAMEOVER_CRASH.bmp", TEXTURE_GAMEOVER_CRASH);
	Texture_Create_Bitmap("assets/GAME_F1RACE_GAMEOVER_FIELD.bmp", TEXTURE_GAMEOVER_FIELD);
}

static void Texture_Draw(Sint32 x, Sint32 y, TEXTURE texture_id) // Renders a specified texture at the given screen coordinates using SDL2.
{
	SDL_Rect rectangle;
	rectangle.x = x;
	rectangle.y = y;
	SDL_QueryTexture(textures[texture_id], NULL, NULL, &rectangle.w, &rectangle.h);
	SDL_RenderCopy(render, textures[texture_id], NULL, &rectangle);
}

static void Texture_Unload(void) { // Frees up memory by destroying textures that have been loaded into memory.
	int i = 0;
	for (; i < TEXTURE_MAX; ++i)
		if (textures[i])
			SDL_DestroyTexture(textures[i]);
}

static void F1Race_Render_Score(Sint16 x_pos, Sint16 y_pos); 

static void F1Race_Show_Game_Over_Screen(void) {
	SDL_SetRenderDrawColor(render, 0, 0, 0, 0); // COLOR FOR GAME OVER SCREEN
	SDL_RenderClear(render);

	Texture_Draw(18, 10, TEXTURE_GAMEOVER);
	Texture_Draw(30, 40, TEXTURE_GAMEOVER_FIELD);

	SDL_Rect rectangle;
	SDL_SetRenderDrawColor(render, 0, 0, 0, 0);
	rectangle.x = 33;
	rectangle.y = 43;
	rectangle.w = 64;
	rectangle.h = 20;
	SDL_RenderFillRect(render, &rectangle);

	Texture_Draw(36, 50, TEXTURE_STATUS_SCORE);
	Texture_Draw(65, 48, TEXTURE_STATUS_BOX);

	F1Race_Render_Score(64, -2);

	Texture_Draw(47, 80, TEXTURE_GAMEOVER_CRASH);
}

static void F1Race_Render_Separator(void) //Render the texture for white dash line 
{
	Sint16 start_y, end_y;

	SDL_Rect rectangle;
	SDL_SetRenderDrawColor(render, 250, 250, 250, 0); 
	rectangle.x = F1RACE_SEPARATOR_0_START_X;
	rectangle.y = F1RACE_DISPLAY_START_Y;
	rectangle.w = F1RACE_SEPARATOR_0_END_X + 1 - rectangle.x;
	rectangle.h = F1RACE_DISPLAY_END_Y - rectangle.y;
	SDL_RenderFillRect(render, &rectangle);

	SDL_SetRenderDrawColor(render, 250, 250, 250, 0);
	rectangle.x = F1RACE_SEPARATOR_1_START_X;
	rectangle.y = F1RACE_DISPLAY_START_Y;
	rectangle.w = F1RACE_SEPARATOR_1_END_X + 1 - rectangle.x;
	rectangle.h = F1RACE_DISPLAY_END_Y - rectangle.y;
	SDL_RenderFillRect(render, &rectangle);

	start_y = f1race_separator_0_block_start_y;
	end_y = start_y + F1RACE_SEPARATOR_HEIGHT_SPACE;
	while (SDL_TRUE) {
		SDL_SetRenderDrawColor(render, 100, 100, 100, 0); // GRAY (LANE SEPARATOR)
		rectangle.x = F1RACE_SEPARATOR_0_START_X;
		rectangle.y = start_y;
		rectangle.w = F1RACE_SEPARATOR_0_END_X + 1 - rectangle.x;
		rectangle.h = end_y - rectangle.y;
		SDL_RenderFillRect(render, &rectangle);

		start_y += F1RACE_SEPARATOR_HEIGHT;
		end_y = start_y + F1RACE_SEPARATOR_HEIGHT_SPACE;
		if (start_y > F1RACE_DISPLAY_END_Y)
			break;
		if (end_y > F1RACE_DISPLAY_END_Y)
			end_y = F1RACE_DISPLAY_END_Y;
	}
	f1race_separator_0_block_start_y += F1RACE_SEPARATOR_HEIGHT_SPACE;
	if (f1race_separator_0_block_start_y >=
		(F1RACE_DISPLAY_START_Y + F1RACE_SEPARATOR_HEIGHT_SPACE * F1RACE_SEPARATOR_RATIO))
		f1race_separator_0_block_start_y = F1RACE_DISPLAY_START_Y;

	start_y = f1race_separator_1_block_start_y;
	end_y = start_y + F1RACE_SEPARATOR_HEIGHT_SPACE;
	while (SDL_TRUE) {
		SDL_SetRenderDrawColor(render, 100, 100, 100, 0); // GRAY (LANE SEPARATOR)
		rectangle.x = F1RACE_SEPARATOR_1_START_X;
		rectangle.y = start_y;
		rectangle.w = F1RACE_SEPARATOR_1_END_X + 1 - rectangle.x;
		rectangle.h = end_y - rectangle.y;
		SDL_RenderFillRect(render, &rectangle);

		start_y += F1RACE_SEPARATOR_HEIGHT;
		end_y = start_y + F1RACE_SEPARATOR_HEIGHT_SPACE;
		if (start_y > F1RACE_DISPLAY_END_Y)
			break;
		if (end_y > F1RACE_DISPLAY_END_Y)
			end_y = F1RACE_DISPLAY_END_Y;
	}
	f1race_separator_1_block_start_y += F1RACE_SEPARATOR_HEIGHT_SPACE;
	if (f1race_separator_1_block_start_y >=
		(F1RACE_DISPLAY_START_Y + F1RACE_SEPARATOR_HEIGHT_SPACE * F1RACE_SEPARATOR_RATIO))
		f1race_separator_1_block_start_y = F1RACE_DISPLAY_START_Y;
}

static void F1Race_Render_Road(void) {
	SDL_Rect rectangle;
	SDL_SetRenderDrawColor(render, 100, 100, 100, 0); // GRAY (ROAD COLOR)
	rectangle.x = F1RACE_ROAD_0_START_X;
	rectangle.y = F1RACE_DISPLAY_START_Y;
	rectangle.w = F1RACE_ROAD_2_END_X + 1 - rectangle.x;
	rectangle.h = F1RACE_DISPLAY_END_Y - rectangle.y;
	SDL_RenderFillRect(render, &rectangle);
}

static void F1Race_Render_Score(Sint16 x_pos, Sint16 y_pos) { // Displaying current score on the game screen.
	Sint16 value;
	Sint16 remain;

	SDL_Rect rectangle;
	SDL_SetRenderDrawColor(render, 0, 0, 0, 0);
	rectangle.x = x_pos + 4;
	rectangle.y = y_pos + 52;
	rectangle.w = x_pos + 29 + 1 - rectangle.x;
	rectangle.h = y_pos + 58 - rectangle.y;
	SDL_RenderFillRect(render, &rectangle);

	value = f1race_score % 10;
	remain = f1race_score / 10;

	while (SDL_TRUE) {
		Texture_Draw(x_pos + 25, y_pos + 52, value);

		x_pos -= 5;
		if (remain > 0) {
			value = remain % 10;
			remain = remain / 10;
		}
		else
			break;
	}
}

static void F1Race_Render_Status(void) 
{
	Sint16 x_pos;
	Sint16 y_pos;
	Sint16 index;

	F1Race_Render_Score(F1RACE_STATUS_START_X, F1RACE_DISPLAY_START_Y);

	SDL_Rect rectangle;
	SDL_SetRenderDrawColor(render, 0, 0, 0, 0); 
	rectangle.x = F1RACE_STATUS_START_X + 4;
	rectangle.y = F1RACE_DISPLAY_START_Y + 74;
	rectangle.w = F1RACE_STATUS_START_X + 29 + 1 - rectangle.x;
	rectangle.h = F1RACE_DISPLAY_START_Y + 80 - rectangle.y;
	SDL_RenderFillRect(render, &rectangle);

	x_pos = F1RACE_STATUS_START_X + 16;
	y_pos = F1RACE_DISPLAY_START_Y + 74;

	Texture_Draw(x_pos, y_pos, f1race_level);

	x_pos = F1RACE_STATUS_START_X + 4;
	y_pos = F1RACE_DISPLAY_START_Y + 102;
	for (index = 0; index < 5; index++) 
	{
		if (index < f1race_fly_charger_count)
			SDL_SetRenderDrawColor(render, 255, 0, 0, 0); // FLY CHARGED
		else
			SDL_SetRenderDrawColor(render, 100, 100, 100, 0); // FLY UNCHARGED
		rectangle.x = x_pos + index * 4;
		rectangle.y = y_pos - 2 - index;
		rectangle.w = x_pos + 2 + index * 4 + 1 - rectangle.x;
		rectangle.h = y_pos - rectangle.y;
		SDL_RenderFillRect(render, &rectangle);
	}

	x_pos = F1RACE_STATUS_START_X + 25;
	y_pos = F1RACE_DISPLAY_START_Y + 96;
	Texture_Draw(x_pos, y_pos, f1race_fly_count);
}

static void F1Race_Render_Player_Car(void) 
{
	Sint16 dx;
	Sint16 dy;

	TEXTURE image;

	if (f1race_player_is_car_fly == SDL_FALSE)
		Texture_Draw(f1race_player_car.pos_x, f1race_player_car.pos_y, TEXTURE_PLAYER_CAR);
	else {
		dx = (F1RACE_PLAYER_CAR_FLY_IMAGE_SIZE_X - F1RACE_PLAYER_CAR_IMAGE_SIZE_X) / 2;
		dy = (F1RACE_PLAYER_CAR_FLY_IMAGE_SIZE_Y - F1RACE_PLAYER_CAR_IMAGE_SIZE_Y) / 2;
		dx = f1race_player_car.pos_x - dx;
		dy = f1race_player_car.pos_y - dy;
		switch (f1race_player_car_fly_duration) {
			case 0:
			case 1:
				image = TEXTURE_PLAYER_CAR_FLY_UP;
				break;
			case (F1RACE_PLAYER_CAR_FLY_FRAME_COUNT - 1):
			case (F1RACE_PLAYER_CAR_FLY_FRAME_COUNT - 2):
				image = TEXTURE_PLAYER_CAR_FLY_DOWN;
				break;
			default:
				image = TEXTURE_PLAYER_CAR_FLY;
				break;
		}
		Texture_Draw(dx, dy, image);
	}
}

static void F1Race_Render_Opposite_Car(void) { // Rendering the opponent cars that the player interacts with.
	Sint16 index;
	for (index = 0; index < F1RACE_OPPOSITE_CAR_COUNT; index++) {
		if (f1race_opposite_car[index].is_empty == SDL_FALSE)
			Texture_Draw(f1race_opposite_car[index].pos_x, f1race_opposite_car[index].pos_y,
				f1race_opposite_car[index].image);
	}
}

static void F1Race_Render_Player_Car_Crash(void) { // Displays an image of the player's car in a crashed state at a specified position.
	Texture_Draw(f1race_player_car.pos_x, f1race_player_car.pos_y - 5, TEXTURE_PLAYER_CAR_CRASH);
}

static void F1Race_Render(void) { // Sets clip regions for rendering specific elements
	SDL_Rect rectangle;
	rectangle.x = F1RACE_STATUS_START_X;
	rectangle.y = F1RACE_DISPLAY_START_Y;
	rectangle.w = F1RACE_STATUS_END_X + 1 - rectangle.x;
	rectangle.h = F1RACE_DISPLAY_END_Y - rectangle.y;
	SDL_RenderSetClipRect(render, &rectangle);

	F1Race_Render_Status();

	rectangle.x = F1RACE_ROAD_0_START_X;
	rectangle.y = F1RACE_DISPLAY_START_Y;
	rectangle.w = F1RACE_ROAD_2_END_X + 1 - rectangle.x;
	rectangle.h = F1RACE_DISPLAY_END_Y - rectangle.y;
	SDL_RenderSetClipRect(render, &rectangle);

	F1Race_Render_Road();
	F1Race_Render_Separator();
	F1Race_Render_Opposite_Car();
	F1Race_Render_Player_Car();
}

static void F1Race_Render_Background(void) {  // Used to draw the background elements of the game, including borders, grass, and status-related textures.
	SDL_Rect rectangle;

	SDL_SetRenderDrawColor(render, 255, 255, 255, 0); // WINDOW BORDER (WHITE)
	SDL_RenderClear(render);

	SDL_SetRenderDrawColor(render, 0, 0, 0, 0); // BLACK
	rectangle.x = F1RACE_DISPLAY_START_X - 1;
	rectangle.y = F1RACE_DISPLAY_START_Y - 1;
	rectangle.w = F1RACE_DISPLAY_END_X + 2 - rectangle.x;
	rectangle.h = F1RACE_DISPLAY_END_Y + 1 - rectangle.y;
	SDL_RenderDrawRect(render, &rectangle);

	SDL_SetRenderDrawColor(render, 0, 0, 0, 0); // BLACK
	rectangle.x = F1RACE_GRASS_0_START_X;
	rectangle.y = F1RACE_DISPLAY_START_Y;
	rectangle.w = F1RACE_GRASS_0_END_X + 1 - rectangle.x;
	rectangle.h = F1RACE_DISPLAY_END_Y - rectangle.y;
	SDL_RenderFillRect(render, &rectangle);

	SDL_SetRenderDrawColor(render, 255, 255, 255, 0); // LEFT LINE BORDER (WHITE)
	SDL_RenderDrawLine(render, F1RACE_GRASS_0_END_X - 1,
		F1RACE_DISPLAY_START_Y, F1RACE_GRASS_0_END_X - 1, F1RACE_DISPLAY_END_Y - 1);

	SDL_SetRenderDrawColor(render, 0, 0, 0, 0); // BLACK
	SDL_RenderDrawLine(render, F1RACE_GRASS_0_END_X,
		F1RACE_DISPLAY_START_Y, F1RACE_GRASS_0_END_X, F1RACE_DISPLAY_END_Y);

	SDL_SetRenderDrawColor(render, 0, 0, 0, 0); // BLACK
	rectangle.x = F1RACE_GRASS_1_START_X;
	rectangle.y = F1RACE_DISPLAY_START_Y;
	rectangle.w = F1RACE_GRASS_1_END_X + 1 - rectangle.x;
	rectangle.h = F1RACE_DISPLAY_END_Y - rectangle.y;
	SDL_RenderFillRect(render, &rectangle);

	SDL_SetRenderDrawColor(render, 255, 255, 255, 0); // RIGHT LINE BORDER (WHITE)
	SDL_RenderDrawLine(render, F1RACE_GRASS_1_START_X + 1,
		F1RACE_DISPLAY_START_Y, F1RACE_GRASS_1_START_X + 1, F1RACE_DISPLAY_END_Y - 1);

	SDL_SetRenderDrawColor(render, 0, 0, 0, 0); // BLACK
	SDL_RenderDrawLine(render, F1RACE_GRASS_1_START_X,
		F1RACE_DISPLAY_START_Y, F1RACE_GRASS_1_START_X, F1RACE_DISPLAY_END_Y);

	SDL_SetRenderDrawColor(render, 0, 0, 0, 0); // BLACK
	rectangle.x = F1RACE_STATUS_START_X;
	rectangle.y = F1RACE_DISPLAY_START_Y;
	rectangle.w = F1RACE_STATUS_END_X + 1 - rectangle.x;
	rectangle.h = F1RACE_DISPLAY_END_Y - rectangle.y;
	SDL_RenderFillRect(render, &rectangle);

	Texture_Draw(F1RACE_STATUS_START_X + 0, F1RACE_DISPLAY_START_Y +  0, TEXTURE_LOGO);
	Texture_Draw(F1RACE_STATUS_START_X + 5, F1RACE_DISPLAY_START_Y + 42, TEXTURE_STATUS_SCORE);
	Texture_Draw(F1RACE_STATUS_START_X + 2, F1RACE_DISPLAY_START_Y + 50, TEXTURE_STATUS_BOX);
	Texture_Draw(F1RACE_STATUS_START_X + 6, F1RACE_DISPLAY_START_Y + 64, TEXTURE_STATUS_LEVEL);
	Texture_Draw(F1RACE_STATUS_START_X + 2, F1RACE_DISPLAY_START_Y + 72, TEXTURE_STATUS_BOX);
	Texture_Draw(F1RACE_STATUS_START_X + 2, F1RACE_DISPLAY_START_Y + 89, TEXTURE_STATUS_FLY);
}

static void F1Race_Init(void) // Set up numerous parameters related to player car, opponent cars, game state, and scoring.
{
	int index;
	f1race_key_up_pressed = SDL_FALSE;
	f1race_key_down_pressed = SDL_FALSE;
	f1race_key_right_pressed = SDL_FALSE;
	f1race_key_left_pressed = SDL_FALSE;

	f1race_separator_0_block_start_y = F1RACE_DISPLAY_START_Y;
	f1race_separator_1_block_start_y = F1RACE_DISPLAY_START_Y + F1RACE_SEPARATOR_HEIGHT_SPACE * 3;
	f1race_player_car.pos_x = ((F1RACE_ROAD_1_START_X + F1RACE_ROAD_1_END_X - F1RACE_PLAYER_CAR_IMAGE_SIZE_X) / 2);
	f1race_player_car.dx = F1RACE_PLAYER_CAR_IMAGE_SIZE_X;
	f1race_player_car.pos_y = F1RACE_DISPLAY_END_Y - F1RACE_PLAYER_CAR_IMAGE_SIZE_Y - 1;
	f1race_player_car.dy = F1RACE_PLAYER_CAR_IMAGE_SIZE_Y;
	f1race_player_car.image = TEXTURE_PLAYER_CAR;
	f1race_player_car.image_fly = TEXTURE_PLAYER_CAR_FLY;
	f1race_player_car.image_head_light = TEXTURE_PLAYER_CAR_HEAD_LIGHT;

	f1race_opposite_car_type[0].dx = F1RACE_OPPOSITE_CAR_0_IMAGE_SIZE_X;
	f1race_opposite_car_type[0].dy = F1RACE_OPPOSITE_CAR_0_IMAGE_SIZE_Y;
	f1race_opposite_car_type[0].image = TEXTURE_OPPOSITE_CAR_0;
	f1race_opposite_car_type[0].speed = 3;
	f1race_opposite_car_type[0].dx_from_road = (F1RACE_ROAD_WIDTH - F1RACE_OPPOSITE_CAR_0_IMAGE_SIZE_X) / 2;

	f1race_opposite_car_type[1].dx = F1RACE_OPPOSITE_CAR_1_IMAGE_SIZE_X;
	f1race_opposite_car_type[1].dy = F1RACE_OPPOSITE_CAR_1_IMAGE_SIZE_Y;
	f1race_opposite_car_type[1].image = TEXTURE_OPPOSITE_CAR_1;
	f1race_opposite_car_type[1].speed = 4;
	f1race_opposite_car_type[1].dx_from_road = (F1RACE_ROAD_WIDTH - F1RACE_OPPOSITE_CAR_1_IMAGE_SIZE_X) / 2;

	f1race_opposite_car_type[2].dx = F1RACE_OPPOSITE_CAR_2_IMAGE_SIZE_X;
	f1race_opposite_car_type[2].dy = F1RACE_OPPOSITE_CAR_2_IMAGE_SIZE_Y;
	f1race_opposite_car_type[2].image = TEXTURE_OPPOSITE_CAR_2;
	f1race_opposite_car_type[2].speed = 6;
	f1race_opposite_car_type[2].dx_from_road = (F1RACE_ROAD_WIDTH - F1RACE_OPPOSITE_CAR_2_IMAGE_SIZE_X) / 2;

	f1race_opposite_car_type[3].dx = F1RACE_OPPOSITE_CAR_3_IMAGE_SIZE_X;
	f1race_opposite_car_type[3].dy = F1RACE_OPPOSITE_CAR_3_IMAGE_SIZE_Y;
	f1race_opposite_car_type[3].image = TEXTURE_OPPOSITE_CAR_3;
	f1race_opposite_car_type[3].speed = 3;
	f1race_opposite_car_type[3].dx_from_road = (F1RACE_ROAD_WIDTH - F1RACE_OPPOSITE_CAR_3_IMAGE_SIZE_X) / 2;

	f1race_opposite_car_type[4].dx = F1RACE_OPPOSITE_CAR_4_IMAGE_SIZE_X;
	f1race_opposite_car_type[4].dy = F1RACE_OPPOSITE_CAR_4_IMAGE_SIZE_Y;
	f1race_opposite_car_type[4].image = TEXTURE_OPPOSITE_CAR_4;
	f1race_opposite_car_type[4].speed = 3;
	f1race_opposite_car_type[4].dx_from_road = (F1RACE_ROAD_WIDTH - F1RACE_OPPOSITE_CAR_4_IMAGE_SIZE_X) / 2;

	f1race_opposite_car_type[5].dx = F1RACE_OPPOSITE_CAR_5_IMAGE_SIZE_X;
	f1race_opposite_car_type[5].dy = F1RACE_OPPOSITE_CAR_5_IMAGE_SIZE_Y;
	f1race_opposite_car_type[5].image = TEXTURE_OPPOSITE_CAR_5;
	f1race_opposite_car_type[5].speed = 5;
	f1race_opposite_car_type[5].dx_from_road = (F1RACE_ROAD_WIDTH - F1RACE_OPPOSITE_CAR_5_IMAGE_SIZE_X) / 2;

	f1race_opposite_car_type[6].dx = F1RACE_OPPOSITE_CAR_6_IMAGE_SIZE_X;
	f1race_opposite_car_type[6].dy = F1RACE_OPPOSITE_CAR_6_IMAGE_SIZE_Y;
	f1race_opposite_car_type[6].image = TEXTURE_OPPOSITE_CAR_6;
	f1race_opposite_car_type[6].speed = 3;
	f1race_opposite_car_type[6].dx_from_road = (F1RACE_ROAD_WIDTH - F1RACE_OPPOSITE_CAR_6_IMAGE_SIZE_X) / 2;

	for (index = 0; index < F1RACE_OPPOSITE_CAR_COUNT; index++) 
	{
		f1race_opposite_car[index].is_empty = SDL_TRUE;
		f1race_opposite_car[index].is_add_score = SDL_FALSE;
	}

	f1race_is_crashing = SDL_FALSE;
	f1race_last_car_road = 0;
	f1race_player_is_car_fly = SDL_FALSE;
	f1race_score = 0;
	f1race_level = 1;
	f1race_pass = 0;
	f1race_fly_count = 1;
	f1race_fly_charger_count = 0;
}

static void F1Race_Main(void) { // Set the primary flow of the game based on certain conditions and handles rendering and music playback.
	if (f1race_is_new_game != SDL_FALSE) {
		F1Race_Init();
		f1race_is_new_game = SDL_FALSE;
	}

	F1Race_Render_Background();
	F1Race_Render();

	if (using_new_background_ogg)
		Music_Play(MUSIC_BACKGROUND, -1);
	else
		Music_Play(MUSIC_BACKGROUND_LOWCOST, -1);
}

static void F1Race_Key_Left_Pressed(void) { // HANDLE LEFT KEY PRESSED
	F1RACE_RELEASE_ALL_KEY;
	f1race_key_left_pressed = SDL_TRUE;
}

static void F1Race_Key_Left_Released(void) {  // HANDLE LEFT KEY RELEASED
	f1race_key_left_pressed = SDL_FALSE;
}

static void F1Race_Key_Right_Pressed(void) { // HANDLE RIGHT KEY PRESSED
	F1RACE_RELEASE_ALL_KEY;
	f1race_key_right_pressed = SDL_TRUE;
}

static void F1Race_Key_Right_Released(void) {  // HANDLE RIGHT KEY RELEASED
	f1race_key_right_pressed = SDL_FALSE;
}

static void F1Race_Key_Up_Pressed(void) { // HANDLE UP KEY PRESSED
	F1RACE_RELEASE_ALL_KEY;
	f1race_key_up_pressed = SDL_TRUE;
}

static void F1Race_Key_Up_Released(void) {  // HANDLE UP KEY RELEASED
	f1race_key_up_pressed = SDL_FALSE;
}

static void F1Race_Key_Down_Pressed(void) { // HANDLE DOWN KEY PRESSED
	F1RACE_RELEASE_ALL_KEY;
	f1race_key_down_pressed = SDL_TRUE;
}

static void F1Race_Key_Down_Released(void) {  // HANDLE FLY KEY RELEASED
	f1race_key_down_pressed = SDL_FALSE;
}

static void F1Race_Key_Fly_Pressed(void) { // HANDLE FLY KEY PRESSED
	if (f1race_player_is_car_fly != SDL_FALSE)
		return;

	if (f1race_fly_count > 0) {
		f1race_player_is_car_fly = SDL_TRUE;
		f1race_player_car_fly_duration = 0;
		f1race_fly_count--;
	}
}

static void F1Race_Keyboard_Key_Handler(Sint32 vkey_code, Sint32 key_state) { // HANDLE ALL KEYPRESSES
	switch (vkey_code) {
		case SDLK_LEFT:
		case SDLK_KP_4:
			(key_state) ? F1Race_Key_Left_Pressed() : F1Race_Key_Left_Released();
			break;
		case SDLK_RIGHT:
		case SDLK_KP_6:
			(key_state) ? F1Race_Key_Right_Pressed() : F1Race_Key_Right_Released();
			break;
		case SDLK_UP:
		case SDLK_2:
		case SDLK_KP_8:
			(key_state) ? F1Race_Key_Up_Pressed() : F1Race_Key_Up_Released();
			break;
		case SDLK_DOWN:
		case SDLK_8:
		case SDLK_KP_2:
			(key_state) ? F1Race_Key_Down_Pressed() : F1Race_Key_Down_Released();
			break;
		case SDLK_SPACE:
		case SDLK_RETURN:
		case SDLK_KP_ENTER:
		case SDLK_5:
		case SDLK_KP_5:
			if (key_state)
				F1Race_Key_Fly_Pressed();
			break;
		case SDLK_n:
		case SDLK_TAB:
		case SDLK_0:
		case SDLK_KP_0:
			if (key_state) {
				if (!using_new_background_ogg)
					Music_Play(MUSIC_BACKGROUND, -1);
				else
					Music_Play(MUSIC_BACKGROUND_LOWCOST, -1);
				using_new_background_ogg = !using_new_background_ogg;
			}
			break;
		case SDLK_m:
		case SDLK_7:
		case SDLK_KP_7:
			if (key_state) {
				if (volume_old == -1)
					volume_old = Mix_VolumeMusic(0);
				else {
					Mix_VolumeMusic(volume_old);
					volume_old = -1;
				}
			}
			break;
		case SDLK_ESCAPE:
			if (key_state)
				exit_main_loop = SDL_TRUE;
			break;
	}
}

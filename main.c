#include "F1_Race.c"

static void F1Race_Crashing(void) {
	Music_Play(MUSIC_CRASH, 0);

	f1race_is_crashing = SDL_TRUE;
	f1race_crashing_count_down = 50;
}

static void F1Race_New_Opposite_Car(void) {
	Sint16 index;
	Sint16 validIndex = 0;
	Sint16 no_slot;
	Sint16 car_type = 0;
	Uint8 road;
	Sint16 car_pos_x = 0;
	Sint16 car_shift;
	Sint16 enough_space;
	Sint16 rand_num;
	Sint16 speed_add;

	no_slot = SDL_TRUE;
	if ((rand() % F1RACE_OPPOSITE_CAR_DEFAULT_APPEAR_RATE) == 0) {
		for (index = 0; index < F1RACE_OPPOSITE_CAR_COUNT; index++) {
			if (f1race_opposite_car[index].is_empty != SDL_FALSE) {
				validIndex = index;
				no_slot = SDL_FALSE;
				break;
			}
		}
	}

	if (no_slot != SDL_FALSE)
		return;

	road = rand() % 3;

	if (road == f1race_last_car_road) {
		road++;
		road %= 3;
	}

	if (f1race_level < 3) {
		rand_num = rand() % 11;
		switch (rand_num) {
			case 0:
			case 1:
				car_type = 0;
				break;
			case 2:
			case 3:
			case 4:
				car_type = 1;
				break;
			case 5:
				car_type = 2;
				break;
			case 6:
			case 7:
				car_type = 3;
				break;
			case 8:
				car_type = 4;
				break;
			case 9:
				car_type = 5;
				break;
			case 10:
				car_type = 6;
				break;
		}
	}

	if (f1race_level >= 3) {
		rand_num = rand() % 11;
		switch (rand_num) {
			case 0:
				car_type = 0;
				break;
			case 1:
			case 2:
				car_type = 1;
				break;
			case 3:
			case 4:
				car_type = 2;
				break;
			case 5:
			case 6:
				car_type = 3;
				break;
			case 7:
				car_type = 4;
				break;
			case 8:
			case 9:
				car_type = 5;
				break;
			case 10:
				car_type = 6;
				break;
		}
	}
	enough_space = SDL_TRUE;
	for (index = 0; index < F1RACE_OPPOSITE_CAR_COUNT; index++) {
		if ((f1race_opposite_car[index].is_empty == SDL_FALSE) &&
			(f1race_opposite_car[index].pos_y < (F1RACE_PLAYER_CAR_IMAGE_SIZE_Y * 1.5)))
			enough_space = SDL_FALSE;
	}

	if (enough_space == SDL_FALSE)
		return;

	speed_add = f1race_level - 1;

	f1race_opposite_car[validIndex].is_empty = SDL_FALSE;
	f1race_opposite_car[validIndex].is_add_score = SDL_FALSE;
	f1race_opposite_car[validIndex].dx = f1race_opposite_car_type[car_type].dx;
	f1race_opposite_car[validIndex].dy = f1race_opposite_car_type[car_type].dy;
	f1race_opposite_car[validIndex].speed = f1race_opposite_car_type[car_type].speed + speed_add;
	f1race_opposite_car[validIndex].dx_from_road = f1race_opposite_car_type[car_type].dx_from_road;
	f1race_opposite_car[validIndex].image = f1race_opposite_car_type[car_type].image;

	car_shift = f1race_opposite_car[validIndex].dx_from_road;

	switch (road) {
	case 0:
		car_pos_x = F1RACE_ROAD_0_START_X + car_shift;
		break;
	case 1:
		car_pos_x = F1RACE_ROAD_1_START_X + car_shift;
		break;
	case 2:
		car_pos_x = F1RACE_ROAD_2_START_X + car_shift;
		break;
	}

	f1race_opposite_car[validIndex].pos_x = car_pos_x;
	f1race_opposite_car[validIndex].pos_y = F1RACE_DISPLAY_START_Y - f1race_opposite_car[validIndex].dy;
	f1race_opposite_car[validIndex].road_id = road;

	f1race_last_car_road = road;
}

static void F1Race_CollisionCheck(void) {
	Sint16 index;
	Sint16 minA_x, minA_y, maxA_x, maxA_y;
	Sint16 minB_x, minB_y, maxB_x, maxB_y;

	minA_x = f1race_player_car.pos_x - 1;
	maxA_x = minA_x + f1race_player_car.dx - 1;
	minA_y = f1race_player_car.pos_y - 1;
	maxA_y = minA_y + f1race_player_car.dy - 1;

	for (index = 0; index < F1RACE_OPPOSITE_CAR_COUNT; index++) {
		if (f1race_opposite_car[index].is_empty == SDL_FALSE) {
			minB_x = f1race_opposite_car[index].pos_x - 1;
			maxB_x = minB_x + f1race_opposite_car[index].dx - 1;
			minB_y = f1race_opposite_car[index].pos_y - 1;
			maxB_y = minB_y + f1race_opposite_car[index].dy - 1;
			if (((minA_x <= minB_x) && (minB_x <= maxA_x)) || ((minA_x <= maxB_x) && (maxB_x <= maxA_x))) {
				if (((minA_y <= minB_y) && (minB_y <= maxA_y)) || ((minA_y <= maxB_y) && (maxB_y <= maxA_y))) {
					F1Race_Crashing();
					return;
				}
			}

			if ((minA_x >= minB_x) && (minA_x <= maxB_x) && (minA_y >= minB_y) && (minA_y <= maxB_y)) {
				F1Race_Crashing();
				return;
			}

			if ((minA_x >= minB_x) && (minA_x <= maxB_x) && (maxA_y >= minB_y) && (maxA_y <= maxB_y)) {
				F1Race_Crashing();
				return;
			}

			if ((maxA_x >= minB_x) && (maxA_x <= maxB_x) && (minA_y >= minB_y) && (minA_y <= maxB_y)) {
				F1Race_Crashing();
				return;
			}

			if ((maxA_x >= minB_x) && (maxA_x <= maxB_x) && (maxA_y >= minB_y) && (maxA_y <= maxB_y)) {
				F1Race_Crashing();
				return;
			}

			if ((maxA_y < minB_y) && (f1race_opposite_car[index].is_add_score == SDL_FALSE)) {
				f1race_score++;
				f1race_pass++;
				f1race_opposite_car[index].is_add_score = SDL_TRUE;

				if (f1race_pass == 10)
					f1race_level++; /* level 2 */
				else if (f1race_pass == 20)
					f1race_level++; /* level 3 */
				else if (f1race_pass == 30)
					f1race_level++; /* level 4 */
				else if (f1race_pass == 40)
					f1race_level++; /* level 5 */
				else if (f1race_pass == 50)
					f1race_level++; /* level 6 */
				else if (f1race_pass == 60)
					f1race_level++; /* level 7 */
				else if (f1race_pass == 70)
					f1race_level++; /* level 8 */
				else if (f1race_pass == 100)
					f1race_level++; /* level 9 */

				f1race_fly_charger_count++;
				if (f1race_fly_charger_count >= 6) {
					if (f1race_fly_count < F1RACE_MAX_FLY_COUNT) {
						f1race_fly_charger_count = 0;
						f1race_fly_count++;
					} else
						f1race_fly_charger_count--;
				}
			}
		}
	}
}

static void F1Race_Framemove(void) {
	Sint16 shift;
	Sint16 max;
	Sint16 index;

	f1race_player_car_fly_duration++;
	if (f1race_player_car_fly_duration == F1RACE_PLAYER_CAR_FLY_FRAME_COUNT)
		f1race_player_is_car_fly = SDL_FALSE;

	shift = F1RACE_PLAYER_CAR_SHIFT;
	if (f1race_key_up_pressed) {
		if (f1race_player_car.pos_y - shift < F1RACE_DISPLAY_START_Y)
			shift = f1race_player_car.pos_y - F1RACE_DISPLAY_START_Y - 1;
		if (f1race_player_is_car_fly == SDL_FALSE)
			f1race_player_car.pos_y -= shift;
	}

	if (f1race_key_down_pressed) {
		max = f1race_player_car.pos_y + f1race_player_car.dy;
		if (max + shift > F1RACE_DISPLAY_END_Y)
			shift = F1RACE_DISPLAY_END_Y - max;
		if (f1race_player_is_car_fly == SDL_FALSE)
			f1race_player_car.pos_y += shift;
	}

	if (f1race_key_right_pressed) {
		max = f1race_player_car.pos_x + f1race_player_car.dx;
		if (max + shift > F1RACE_ROAD_2_END_X)
			shift = F1RACE_ROAD_2_END_X - max;
		f1race_player_car.pos_x += shift;
	}

	if (f1race_key_left_pressed) {
		if (f1race_player_car.pos_x - shift < F1RACE_ROAD_0_START_X)
			shift = f1race_player_car.pos_x - F1RACE_ROAD_0_START_X - 1;
		f1race_player_car.pos_x -= shift;
	}

	for (index = 0; index < F1RACE_OPPOSITE_CAR_COUNT; index++) {
		if (f1race_opposite_car[index].is_empty == SDL_FALSE) {
			f1race_opposite_car[index].pos_y += f1race_opposite_car[index].speed;
			if (f1race_opposite_car[index].pos_y > (F1RACE_DISPLAY_END_Y + f1race_opposite_car[index].dy))
				f1race_opposite_car[index].is_empty = SDL_TRUE;
		}
	}

	if (f1race_player_is_car_fly != SDL_FALSE) {
		shift = F1RACE_PLAYER_CAR_FLY_SHIFT;
		if (f1race_player_car.pos_y - shift < F1RACE_DISPLAY_START_Y)
			shift = f1race_player_car.pos_y - F1RACE_DISPLAY_START_Y - 1;
		f1race_player_car.pos_y -= shift;
	} else
		F1Race_CollisionCheck();

	F1Race_New_Opposite_Car();
}

/* === END LOGIC CODE === */


// main 
static void F1Race_Cyclic_Timer(void) {
	if (f1race_is_crashing == SDL_FALSE) {
		F1Race_Framemove();
		F1Race_Render();
	} else {
		f1race_crashing_count_down--;
		if (f1race_crashing_count_down >= 40)
			F1Race_Render_Player_Car_Crash();
		else {
			if (f1race_crashing_count_down == 39)
				Music_Play(MUSIC_GAMEOVER, 0);
			F1Race_Show_Game_Over_Screen();
		}
		if (f1race_crashing_count_down <= 0) {
			f1race_is_crashing = SDL_FALSE;
			f1race_is_new_game = SDL_TRUE;
			F1Race_Main();
		}
	}
}

static void main_loop(SDL_Texture *texture) {
	SDL_Event event;
	while (SDL_PollEvent(&event)) {
		switch (event.type) {
			case SDL_QUIT:
				exit_main_loop = SDL_TRUE;
				break;
			case SDL_KEYDOWN:
				F1Race_Keyboard_Key_Handler(event.key.keysym.sym, SDL_TRUE);
				break;
			case SDL_KEYUP:
				F1Race_Keyboard_Key_Handler(event.key.keysym.sym, SDL_FALSE);
				break;
		}
	}
	SDL_SetRenderTarget(render, texture);
	F1Race_Cyclic_Timer();
	SDL_SetRenderTarget(render, NULL);
	SDL_Rect rectangle;
	rectangle.x = 0;
	rectangle.y = 0;
	rectangle.w = WINDOW_WIDTH;
	rectangle.h = WINDOW_HEIGHT;
	SDL_RenderCopy(render, texture, &rectangle, NULL);
	SDL_RenderPresent(render);
}

int main(SDL_UNUSED int argc, SDL_UNUSED char *argv[]) {
	srand(time(0));

	if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO) != 0) {
		fprintf(stderr, "SDL_Init Error: %s.\n", SDL_GetError());
		return EXIT_FAILURE;
	}

#if defined(_WIN32)
	SDL_SetHint(SDL_HINT_RENDER_DRIVER, "software");
#endif
	SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "nearest");

	SDL_Window *window = SDL_CreateWindow("F1 Race",
		SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, WINDOW_WIDTH, WINDOW_HEIGHT,
		SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);
	if (window == NULL) {
		fprintf(stderr, "SDL_CreateWindow Error: %s.\n", SDL_GetError());
		return EXIT_FAILURE;
	}

	SDL_Surface *icon = SDL_LoadBMP("assets/GAME_F1RACE_ICON.bmp");
	if (icon == NULL)
		fprintf(stderr, "SDL_LoadBMP Error: %s.\n", SDL_GetError());
	else {
		SDL_SetColorKey(icon, SDL_TRUE, SDL_MapRGB(icon->format, 36, 227, 113)); // Icon transparent mask.
		SDL_SetWindowIcon(window, icon);
		SDL_FreeSurface(icon);
	}

	render = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_TARGETTEXTURE);
	if (render == NULL) {
		fprintf(stderr, "SDL_CreateRenderer Error: %s.\n", SDL_GetError());
		SDL_DestroyWindow(window);
		SDL_Quit();
		return EXIT_FAILURE;
	}

	Texture_Load();

	int result = Mix_Init(MIX_INIT_OGG);
	if (result != MIX_INIT_OGG) {
		fprintf(stderr, "Mix_Init Error: %s.\n", Mix_GetError());
		return EXIT_FAILURE;
	}
	if (Mix_OpenAudio(44100, AUDIO_S16SYS, 1, 4096) == -1) {
		fprintf(stderr, "Mix_OpenAudio Error: %s.\n", Mix_GetError());
		return EXIT_FAILURE;
	}

	Music_Load();

	SDL_SetRenderTarget(render, textures[TEXTURE_SCREEN]);
	SDL_RenderClear(render);
	F1Race_Main();
	SDL_SetRenderTarget(render, NULL);


	while (!exit_main_loop) {
		main_loop(textures[TEXTURE_SCREEN]);
		SDL_Delay(F1RACE_TIMER_ELAPSE); // 10 FPS.
	}

	Mix_CloseAudio();
	Music_Unload();
	Texture_Unload();

	SDL_DestroyRenderer(render);
	SDL_DestroyWindow(window);
	SDL_Quit();

	return EXIT_SUCCESS;
}
#ifndef F1_RACE_H
#define F1_RACE_H

#include <SDL2/SDL.h>
#include <SDL2/SDL_mixer.h>

#include <stdio.h>
#include <stdlib.h>

#include <time.h>

#define WINDOW_WIDTH                                   (512)
#define WINDOW_HEIGHT                                  (512)
#define TEXTURE_WIDTH                                  (128)
#define TEXTURE_HEIGHT                                 (128)

#define F1RACE_PLAYER_CAR_IMAGE_SIZE_X                 (15)
#define F1RACE_PLAYER_CAR_IMAGE_SIZE_Y                 (20)
#define F1RACE_PLAYER_CAR_CARSH_IMAGE_SIZE_X           (15)
#define F1RACE_PLAYER_CAR_CARSH_IMAGE_SIZE_Y           (25)
#define F1RACE_PLAYER_CAR_FLY_IMAGE_SIZE_X             (23)
#define F1RACE_PLAYER_CAR_FLY_IMAGE_SIZE_Y             (27)
#define F1RACE_PLAYER_CAR_HEAD_LIGHT_IMAGE_SIZE_X      (7)
#define F1RACE_PLAYER_CAR_HEAD_LIGHT_IMAGE_SIZE_Y      (15)
#define F1RACE_PLAYER_CAR_HEAD_LIGHT_0_SHIFT           (1)
#define F1RACE_PLAYER_CAR_HEAD_LIGHT_1_SHIFT           (7)
#define F1RACE_OPPOSITE_CAR_TYPE_COUNT                 (7)
#define F1RACE_PLAYER_CAR_FLY_FRAME_COUNT              (10)
#define F1RACE_OPPOSITE_CAR_0_IMAGE_SIZE_X             (17)
#define F1RACE_OPPOSITE_CAR_0_IMAGE_SIZE_Y             (35)
#define F1RACE_OPPOSITE_CAR_1_IMAGE_SIZE_X             (12)
#define F1RACE_OPPOSITE_CAR_1_IMAGE_SIZE_Y             (18)
#define F1RACE_OPPOSITE_CAR_2_IMAGE_SIZE_X             (15)
#define F1RACE_OPPOSITE_CAR_2_IMAGE_SIZE_Y             (20)
#define F1RACE_OPPOSITE_CAR_3_IMAGE_SIZE_X             (12)
#define F1RACE_OPPOSITE_CAR_3_IMAGE_SIZE_Y             (18)
#define F1RACE_OPPOSITE_CAR_4_IMAGE_SIZE_X             (17)
#define F1RACE_OPPOSITE_CAR_4_IMAGE_SIZE_Y             (27)
#define F1RACE_OPPOSITE_CAR_5_IMAGE_SIZE_X             (13)
#define F1RACE_OPPOSITE_CAR_5_IMAGE_SIZE_Y             (21)
#define F1RACE_OPPOSITE_CAR_6_IMAGE_SIZE_X             (13)
#define F1RACE_OPPOSITE_CAR_6_IMAGE_SIZE_Y             (22)
#define F1RACE_OPPOSITE_CAR_COUNT                      (8)
#define F1RACE_OPPOSITE_CAR_DEFAULT_APPEAR_RATE        (2)
#define F1RACE_MAX_FLY_COUNT                           (9)
#define F1RACE_TIMER_ELAPSE                            (100)
#define F1RACE_PLAYER_CAR_SHIFT                        (5)
#define F1RACE_PLAYER_CAR_FLY_SHIFT                    (2)
#define F1RACE_DISPLAY_START_X                         (3)
#define F1RACE_DISPLAY_START_Y                         (3)
#define F1RACE_DISPLAY_END_X                           (124)
#define F1RACE_DISPLAY_END_Y                           (124)
#define F1RACE_ROAD_WIDTH                              (23)
#define F1RACE_SEPARATOR_WIDTH                         (3)
#define F1RACE_GRASS_WIDTH                             (7)
#define F1RACE_STATUS_WIDTH                            (32)
#define F1RACE_SEPARATOR_HEIGHT_SPACE                  (3)
#define F1RACE_SEPARATOR_RATIO                         (6)
#define F1RACE_SEPARATOR_HEIGHT                        (F1RACE_SEPARATOR_HEIGHT_SPACE*F1RACE_SEPARATOR_RATIO)
#define F1RACE_STATUS_NUMBER_WIDTH                     (4)
#define F1RACE_STATUS_NUBBER_HEIGHT                    (7)
#define F1RACE_GRASS_0_START_X                         (F1RACE_DISPLAY_START_X)
#define F1RACE_GRASS_0_END_X                           (F1RACE_GRASS_0_START_X + F1RACE_GRASS_WIDTH)-1
#define F1RACE_ROAD_0_START_X                          (F1RACE_GRASS_0_START_X + F1RACE_GRASS_WIDTH)
#define F1RACE_ROAD_0_END_X                            (F1RACE_ROAD_0_START_X + F1RACE_ROAD_WIDTH)-1
#define F1RACE_SEPARATOR_0_START_X                     (F1RACE_ROAD_0_START_X + F1RACE_ROAD_WIDTH)
#define F1RACE_SEPARATOR_0_END_X                       (F1RACE_SEPARATOR_0_START_X + F1RACE_SEPARATOR_WIDTH)-1
#define F1RACE_ROAD_1_START_X                          (F1RACE_SEPARATOR_0_START_X + F1RACE_SEPARATOR_WIDTH)
#define F1RACE_ROAD_1_END_X                            (F1RACE_ROAD_1_START_X + F1RACE_ROAD_WIDTH)-1
#define F1RACE_SEPARATOR_1_START_X                     (F1RACE_ROAD_1_START_X + F1RACE_ROAD_WIDTH)
#define F1RACE_SEPARATOR_1_END_X                       (F1RACE_SEPARATOR_1_START_X + F1RACE_SEPARATOR_WIDTH)-1
#define F1RACE_ROAD_2_START_X                          (F1RACE_SEPARATOR_1_START_X + F1RACE_SEPARATOR_WIDTH)
#define F1RACE_ROAD_2_END_X                            (F1RACE_ROAD_2_START_X + F1RACE_ROAD_WIDTH)-1
#define F1RACE_GRASS_1_START_X                         (F1RACE_ROAD_2_START_X + F1RACE_ROAD_WIDTH)
#define F1RACE_GRASS_1_END_X                           (F1RACE_GRASS_1_START_X + F1RACE_GRASS_WIDTH)-1
#define F1RACE_STATUS_START_X                          (F1RACE_GRASS_1_START_X + F1RACE_GRASS_WIDTH)
#define F1RACE_STATUS_END_X                            (F1RACE_STATUS_START_X + F1RACE_STATUS_WIDTH)

#define F1RACE_RELEASE_ALL_KEY {                       \
    f1race_key_up_pressed      = SDL_FALSE;            \
    f1race_key_down_pressed    = SDL_FALSE;            \
    f1race_key_left_pressed    = SDL_FALSE;            \
    f1race_key_right_pressed   = SDL_FALSE;            \
    if (f1race_is_crashing == SDL_TRUE)                \
        return;                                        \
}                                                      \

typedef enum MUSIC_TRACKS {
	MUSIC_BACKGROUND,
	MUSIC_BACKGROUND_LOWCOST,
	MUSIC_CRASH,
	MUSIC_GAMEOVER,
	MUSIC_MAX
} MUSIC_TRACK;

typedef enum TEXTURES {
	TEXTURE_NUMBER_0,
	TEXTURE_NUMBER_1,
	TEXTURE_NUMBER_2,
	TEXTURE_NUMBER_3,
	TEXTURE_NUMBER_4,
	TEXTURE_NUMBER_5,
	TEXTURE_NUMBER_6,
	TEXTURE_NUMBER_7,
	TEXTURE_NUMBER_8,
	TEXTURE_NUMBER_9,
	TEXTURE_SCREEN,
	TEXTURE_PLAYER_CAR,
	TEXTURE_PLAYER_CAR_FLY,
	TEXTURE_PLAYER_CAR_FLY_UP,
	TEXTURE_PLAYER_CAR_FLY_DOWN,
	TEXTURE_PLAYER_CAR_HEAD_LIGHT,
	TEXTURE_PLAYER_CAR_CRASH,
	TEXTURE_LOGO,
	TEXTURE_STATUS_SCORE,
	TEXTURE_STATUS_BOX,
	TEXTURE_STATUS_LEVEL,
	TEXTURE_STATUS_FLY,
	TEXTURE_OPPOSITE_CAR_0,
	TEXTURE_OPPOSITE_CAR_1,
	TEXTURE_OPPOSITE_CAR_2,
	TEXTURE_OPPOSITE_CAR_3,
	TEXTURE_OPPOSITE_CAR_4,
	TEXTURE_OPPOSITE_CAR_5,
	TEXTURE_OPPOSITE_CAR_6,
	TEXTURE_GAMEOVER,
	TEXTURE_GAMEOVER_FIELD,
	TEXTURE_GAMEOVER_CRASH,
	TEXTURE_MAX
} TEXTURE;

static Mix_Music *music_tracks[MUSIC_MAX] = { NULL };
static Sint32 volume_old = -1;

static SDL_Texture *textures[TEXTURE_MAX] = { NULL };

static SDL_bool exit_main_loop = SDL_FALSE;
static SDL_bool using_new_background_ogg = SDL_FALSE;
static SDL_Renderer *render = NULL;

static SDL_bool f1race_is_new_game = SDL_TRUE;
static SDL_bool f1race_is_crashing = SDL_FALSE;
static Sint16 f1race_crashing_count_down;
static Sint16 f1race_separator_0_block_start_y;
static Sint16 f1race_separator_1_block_start_y;
static Sint16 f1race_last_car_road;
static SDL_bool f1race_player_is_car_fly;
static Sint16 f1race_player_car_fly_duration;
static Sint16 f1race_score;
static Sint16 f1race_level;
static Sint16 f1race_pass;
static Sint16 f1race_fly_count;
static Sint16 f1race_fly_charger_count;

static SDL_bool f1race_key_up_pressed = SDL_FALSE;
static SDL_bool f1race_key_down_pressed = SDL_FALSE;
static SDL_bool f1race_key_right_pressed = SDL_FALSE;
static SDL_bool f1race_key_left_pressed = SDL_FALSE;

typedef struct {
	Sint16 pos_x;
	Sint16 pos_y;
	Sint16 dx;
	Sint16 dy;
	TEXTURE image;
	TEXTURE image_fly;
	TEXTURE image_head_light;
} F1RACE_CAR_STRUCT;

typedef struct {
	Sint16 dx;
	Sint16 dy;
	Sint16 speed;
	Sint16 dx_from_road;
	TEXTURE image;
} F1RACE_OPPOSITE_CAR_TYPE_STRUCT;

typedef struct {
	Sint16 dx;
	Sint16 dy;
	Sint16 speed;
	Sint16 dx_from_road;
	TEXTURE image;
	Sint16 pos_x;
	Sint16 pos_y;
	Uint8 road_id;
	SDL_bool is_empty;
	SDL_bool is_add_score;
} F1RACE_OPPOSITE_CAR_STRUCT;

static F1RACE_CAR_STRUCT f1race_player_car;
static F1RACE_OPPOSITE_CAR_TYPE_STRUCT f1race_opposite_car_type[F1RACE_OPPOSITE_CAR_TYPE_COUNT];
static F1RACE_OPPOSITE_CAR_STRUCT f1race_opposite_car[F1RACE_OPPOSITE_CAR_COUNT];

static void Music_Load(void);

static void Music_Play(MUSIC_TRACK track, Sint32 loop);

static void Music_Unload(void);

static void Texture_Create_Bitmap(const char *filepath, TEXTURE texture_id);

static void Texture_Load(void);

static void Texture_Draw(Sint32 x, Sint32 y, TEXTURE texture_id);

static void Texture_Unload(void);

static void F1Race_Render_Score(Sint16 x_pos, Sint16 y_pos);

static void F1Race_Show_Game_Over_Screen(void);

static void F1Race_Render_Separator(void);

static void F1Race_Render_Road(void);

static void F1Race_Render_Score(Sint16 x_pos, Sint16 y_pos);

static void F1Race_Render_Status(void);

static void F1Race_Render_Player_Car(void);

static void F1Race_Render_Opposite_Car(void);

static void F1Race_Render_Player_Car_Crash(void);

static void F1Race_Render(void);

static void F1Race_Render_Background(void);

static void F1Race_Init(void);

static void F1Race_Main(void);

static void F1Race_Key_Left_Pressed(void);

static void F1Race_Key_Left_Released(void);

static void F1Race_Key_Right_Pressed(void);

static void F1Race_Key_Right_Released(void);

static void F1Race_Key_Up_Pressed(void);

static void F1Race_Key_Up_Released(void);

static void F1Race_Key_Down_Pressed(void);

static void F1Race_Key_Down_Released(void);

static void F1Race_Key_Fly_Pressed(void);

static void F1Race_Keyboard_Key_Handler(Sint32 vkey_code, Sint32 key_state);

#endif // F1_RACE_H
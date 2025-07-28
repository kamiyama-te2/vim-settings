#include QMK_KEYBOARD_H
#include "quantum.h"

// Vim機能用のカスタムキーコード
enum custom_keycodes {
    QUIT_VIM = SAFE_RANGE,
    VIM_A, VIM_O, VIM_SHIFT_A, VIM_SHIFT_I, VIM_SHIFT_O, VIM_U, VIM_X, VIM_V, VIM_SHIFT_V,
    VIM_ESC_VIS, VIM_Y, VIM_P, VIM_SHIFT_P, VIM_SHIFT_G, VIM_W, VIM_B,
};

// Vim状態管理変数
bool is_visual_mode = false;
bool is_visual_line_mode = false;
bool is_clipboard_visual_line = false;
bool d_pending = false;
bool y_pending = false;

// タップダンス用
enum tap_dance_keycodes {
    VIM_DD,
    VIM_YY,
    VIM_GG,
    VIM_D_COMBO,    // d, dw, dd の複合タップダンス
    VIM_B_COMBO,    // b, db の複合タップダンス
};

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  // keymap for default (VIA)
  [0] = LAYOUT_universal(
    TO(3)    , KC_Q     , KC_W     , KC_E     , KC_R     , KC_T     ,                                        KC_Y     , KC_U     , KC_I     , KC_O     , KC_P     , KC_BSPC  ,
    KC_TAB   , KC_A     , KC_S     , KC_D     , KC_F     , KC_G     ,                                        KC_H     , KC_J     , KC_K     , KC_L     , KC_MINS  , KC_ENT   ,
    KC_LSFT  , KC_Z     , KC_X     , KC_C     , KC_V     , KC_B     ,                                        KC_N     , KC_M     , KC_BTN1  , KC_BTN2  , MO(3)    , KC_F4    ,
              KC_LCTL, KC_LALT,LT(1,KC_LNG1),KC_SPC,KC_DEL,                  KC_ESC,LT(2,KC_ENT), KC_LCTL,     KC_LGUI  , KC_RALT
  ),

  [1] = LAYOUT_universal(
      TO(0)    , _______  , S(KC_7)  , S(KC_MINS), KC_MINS  , S(KC_DOT),                                        S(KC_DOT), S(KC_1)  , S(KC_6)  , S(KC_EQL), _______  ,
      _______  , _______  , S(KC_4)  , S(KC_5)  , S(KC_6)  , KC_0     ,                                        KC_1     , KC_EQL, KC_MINS  , S(KC_7)  , _______  ,
      _______  , _______  , S(KC_1)  , S(KC_2)  , S(KC_3)  , S(KC_SLSH),                                       KC_BSLS  , S(KC_SLSH), _______  , _______  , _______  ,
                    _______  , _______  , _______  ,         _______  , _______  ,                   _______  , _______  , _______       , _______  , _______
  ),

  [2] = LAYOUT_universal(
      TO(0)    , _______  , KC_7     , KC_8     , KC_9     , S(KC_9)  ,                                         S(KC_0)  , KC_F7    , KC_F8    , KC_F9    , KC_F10   ,
      _______  , _______  , KC_4     , KC_5     , KC_6     , KC_LBRC  ,                                         KC_RBRC  , KC_F4    , KC_F5    , KC_F6    , KC_F11   ,
      _______  , _______  , KC_1     , KC_2     , KC_3     , S(KC_LBRC),                                         S(KC_RBRC), KC_F1   , KC_F2    , KC_F3    , KC_F12   ,
                    KC_0     , KC_DOT  , _______  ,         _______  , _______  ,                   _______  , _______  , _______       , _______  , _______
  ),

  // Layer 3: Vim Normal Mode
  [3] = LAYOUT_universal(
    QUIT_VIM , _______ , VIM_W   , _______ , _______ , _______  ,                                        TD(VIM_YY), VIM_U   , QUIT_VIM, VIM_O   , VIM_P   , _______  ,
    _______  , VIM_A   , _______ , TD(VIM_D_COMBO), _______ , TD(VIM_GG),                              KC_LEFT , KC_DOWN , KC_UP   , KC_RGHT , _______ , _______  ,
    _______  , _______ , VIM_X   , _______ , VIM_V   , TD(VIM_B_COMBO),                                _______ , _______ , _______ , _______ , _______ , _______  ,
                  _______ , _______ , _______  ,        _______ , _______  ,                   _______ , _______ , _______       , _______ , _______
  ),

  // Layer 4: Vim Normal Mode Shifted
  [4] = LAYOUT_universal(
    _______ , _______ , _______ , _______ , _______ , _______  ,                                        _______ , _______ , VIM_SHIFT_I, VIM_SHIFT_O, VIM_SHIFT_P, _______,
    _______ , VIM_SHIFT_A, _______ , _______ , _______ , VIM_SHIFT_G,                                   KC_LEFT , KC_DOWN , KC_UP   , KC_RGHT , _______ , _______  ,
    _______ , _______ , _______ , _______ , VIM_SHIFT_V, VIM_B ,                                        _______ , _______ , _______ , _______ , _______ , _______  ,
                  _______ , _______ , _______  ,        _______ , _______  ,                   _______ , _______ , _______       , _______ , _______
  ),

  // Layer 5: Vim Visual Line Mode
  [5] = LAYOUT_universal(
    _______ , _______ , VIM_W   , _______ , _______ , _______  ,                                        _______ , _______ , VIM_SHIFT_I, VIM_SHIFT_O, _______ , _______  ,
    _______ , KC_NO   , _______ , TD(VIM_D_COMBO), _______ , VIM_SHIFT_G,                             KC_NO   , _______, _______, KC_NO   , _______ , _______  ,
    _______ , _______ , _______ , _______ , _______ , TD(VIM_B_COMBO),                                _______ , _______ , _______ , _______ , _______ , _______  ,
                  _______ , _______ , _______  ,        _______ , _______  ,                   _______ , _______ , VIM_ESC_VIS   , _______ , _______
  ),
};
// clang-format on

layer_state_t layer_state_set_user(layer_state_t state) {
    // Auto enable scroll mode when the highest layer is 3
    keyball_set_scroll_mode(get_highest_layer(state) == 3);
    return state;
}

// タップダンス関数
void vim_dd(tap_dance_state_t *state, void *user_data) {
    if (state->count == 2) {
        SEND_STRING(SS_TAP(X_HOME));
        SEND_STRING(SS_DOWN(X_LSFT));
        SEND_STRING(SS_TAP(X_END));
        SEND_STRING(SS_UP(X_LSFT));
        SEND_STRING(SS_LCTL("x"));
        SEND_STRING(SS_TAP(X_HOME));
        SEND_STRING(SS_TAP(X_BSPC));
        is_clipboard_visual_line = true;
    }
}

void vim_yy(tap_dance_state_t *state, void *user_data) {
    if (state->count == 1) {
        if (is_visual_mode) {
            SEND_STRING(SS_UP(X_LSFT)); // for visual mode
            SEND_STRING(SS_LCTL("c"));
            SEND_STRING(SS_TAP(X_LEFT));
            is_visual_mode = false;
            if (is_visual_line_mode) {
                is_clipboard_visual_line = true;
            } else {
                is_clipboard_visual_line = false;
            }
        }
        is_clipboard_visual_line = false;
    } else if (state->count == 2) {
        SEND_STRING(SS_TAP(X_HOME));
        SEND_STRING(SS_DOWN(X_LSFT));
        SEND_STRING(SS_TAP(X_END));
        SEND_STRING(SS_UP(X_LSFT));
        SEND_STRING(SS_LCTL("c"));
        SEND_STRING(SS_TAP(X_HOME));
        is_clipboard_visual_line = true;
    }
}

// gg タップダンス関数（ファイル先頭に移動）
void vim_gg(tap_dance_state_t *state, void *user_data) {
    if (state->count == 2) {
        if (is_visual_mode && is_visual_line_mode) {
            // Visual Line モードでgg：先頭行まで選択
            SEND_STRING(SS_LCTL(SS_TAP(X_HOME)));
            SEND_STRING(SS_TAP(X_END));
        } else if (is_visual_mode) {
            // Visual モードでgg：先頭まで選択
            SEND_STRING(SS_LCTL(SS_TAP(X_HOME)));
        } else {
            // Normal モードでgg：先頭に移動
            SEND_STRING(SS_LCTL(SS_TAP(X_HOME)));
        }
    }
}

// d系統の複合タップダンス関数（d単体、dd）
void vim_d_combo(tap_dance_state_t *state, void *user_data) {
    if (state->count == 1) {
        // 'd' 単体 - ペンディング状態にする
        d_pending = true;
    } else if (state->count == 2) {
        // 'dd' - 行削除
        SEND_STRING(SS_TAP(X_HOME));
        SEND_STRING(SS_DOWN(X_LSFT));
        SEND_STRING(SS_TAP(X_END));
        SEND_STRING(SS_UP(X_LSFT));
        SEND_STRING(SS_LCTL("x"));
        SEND_STRING(SS_TAP(X_HOME));
        SEND_STRING(SS_TAP(X_BSPC));
        is_clipboard_visual_line = true;
        d_pending = false;
    }
}

// y系統の複合タップダンス関数（y単体、yy）
void vim_y_combo(tap_dance_state_t *state, void *user_data) {
    if (state->count == 1) {
        // 'y' 単体 - ペンディング状態にする
        y_pending = true;
    } else if (state->count == 2) {
        // 'yy' - 行コピー
        SEND_STRING(SS_TAP(X_HOME));
        SEND_STRING(SS_DOWN(X_LSFT));
        SEND_STRING(SS_TAP(X_END));
        SEND_STRING(SS_UP(X_LSFT));
        SEND_STRING(SS_LCTL("c"));
        SEND_STRING(SS_TAP(X_HOME));
        is_clipboard_visual_line = true;
        y_pending = false;
    }
}

// b系統の複合タップダンス関数（b単体、db）
void vim_b_combo(tap_dance_state_t *state, void *user_data) {
    if (state->count == 1) {
        // 'b' 単体 - 前の単語へ移動
        if (is_visual_mode) {
            // Visual モードでは選択を維持しながら前の単語へ
            SEND_STRING(SS_LCTL(SS_TAP(X_LEFT)));
        } else {
            // Normal モードでは単純に前の単語へ移動
            SEND_STRING(SS_LCTL(SS_TAP(X_LEFT)));
        }
    } else if (state->count == 2) {
        // 'db' - 前の単語まで削除
        if (is_visual_mode) {
            // Visual モードの場合：選択範囲をクリアしてから実行
            SEND_STRING(SS_UP(X_LSFT));
            is_visual_mode = false;
            is_visual_line_mode = false;
        }

        // 現在位置から前の単語の先頭まで選択して削除
        SEND_STRING(SS_DOWN(X_LSFT));
        SEND_STRING(SS_LCTL(SS_TAP(X_LEFT)));
        SEND_STRING(SS_UP(X_LSFT));
        SEND_STRING(SS_LCTL("x"));
        is_clipboard_visual_line = false;
    }
}

tap_dance_action_t tap_dance_actions[] = {
    [VIM_DD] = ACTION_TAP_DANCE_FN(vim_dd),
    [VIM_YY] = ACTION_TAP_DANCE_FN(vim_yy),
    [VIM_GG] = ACTION_TAP_DANCE_FN(vim_gg),
    [VIM_D_COMBO] = ACTION_TAP_DANCE_FN(vim_d_combo),
    [VIM_B_COMBO] = ACTION_TAP_DANCE_FN(vim_b_combo),
};

// Vimカスタムキーコード処理
bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case QUIT_VIM:
            if (record->event.pressed) {
                SEND_STRING(SS_UP(X_LSFT));
                layer_off(3); layer_off(4); layer_off(5);
            }
            return false;
        case VIM_A:
            if (record->event.pressed) {
                SEND_STRING(SS_TAP(X_RIGHT) SS_UP(X_LSFT));
                layer_off(3);
            }
            return false;
        case VIM_SHIFT_A:
            if (record->event.pressed) {
                SEND_STRING(SS_TAP(X_END) SS_UP(X_LSFT));
                layer_off(4); layer_off(3);
            }
            return false;
        case VIM_O:
            if (record->event.pressed) {
                SEND_STRING(SS_TAP(X_END) SS_TAP(X_ENTER) SS_UP(X_LSFT));
                layer_off(3);
            }
            return false;
        case VIM_SHIFT_O:
            if (record->event.pressed) {
                SEND_STRING(SS_TAP(X_HOME) SS_TAP(X_ENTER));
                layer_off(4);
                SEND_STRING(SS_UP(X_LSFT));
                layer_off(3);
                SEND_STRING(SS_TAP(X_UP));
            }
            return false;
        case VIM_SHIFT_I:
            if (record->event.pressed) {
                SEND_STRING(SS_TAP(X_HOME));
                layer_off(4);
                SEND_STRING(SS_UP(X_LSFT));
                layer_off(3);
            }
            return false;
        case VIM_SHIFT_G:
            if (record->event.pressed) {
                SEND_STRING(SS_LCTL(SS_TAP(X_END)));
            }
            return false;
        case VIM_P:
            if (record->event.pressed) {
                if (is_clipboard_visual_line) {
                    SEND_STRING(SS_TAP(X_END) SS_TAP(X_ENTER) SS_LCTL("v"));
                } else {
                    SEND_STRING(SS_TAP(X_RIGHT) SS_LCTL("v"));
                }
            }
            return false;
        case VIM_SHIFT_P:
            if (record->event.pressed) {
                if (is_clipboard_visual_line) {
                    SEND_STRING(SS_TAP(X_HOME) SS_TAP(X_ENTER) SS_LCTL("v"));
                } else {
                    SEND_STRING(SS_LCTL("v"));
                }
            }
            return false;
        case VIM_U:
            if (record->event.pressed) {
                SEND_STRING(SS_LCTL("z"));
            }
            return false;
        case VIM_V:
            if (record->event.pressed) {
                is_visual_mode = true;
                SEND_STRING(SS_DOWN(X_LSFT) SS_TAP(X_RIGHT));
            }
            return false;
        case VIM_SHIFT_V:
            if (record->event.pressed) {
                is_visual_mode = true;
                is_visual_line_mode = true;
                layer_on(5); layer_on(3); layer_off(4);
                SEND_STRING(SS_TAP(X_HOME) SS_DOWN(X_LSFT) SS_TAP(X_END));
            }
            return false;
        case VIM_ESC_VIS:
            if (record->event.pressed) {
                if (is_visual_mode) {
                    is_visual_mode = false;
                    is_visual_line_mode = false;
                    SEND_STRING(SS_UP(X_LSFT) SS_TAP(X_LEFT));
                    layer_off(5);
                }
                SEND_STRING(SS_TAP(X_ESCAPE));
            }
            return false;
        case VIM_X:
            if (record->event.pressed) {
                if (is_visual_mode) {
                    SEND_STRING(SS_UP(X_LSFT) SS_LCTL("x"));
                    is_visual_mode = false;
                    is_clipboard_visual_line = is_visual_line_mode;
                } else {
                    SEND_STRING(SS_DOWN(X_LSFT) SS_TAP(X_RIGHT) SS_UP(X_LSFT) SS_LCTL("x"));
                    is_clipboard_visual_line = false;
                }
            }
            return false;
        case VIM_Y:
            if (record->event.pressed) {
                if (is_visual_mode) {
                    SEND_STRING(SS_UP(X_LSFT) SS_LCTL("c") SS_TAP(X_LEFT));
                    is_visual_mode = false;
                    is_clipboard_visual_line = is_visual_line_mode;
                }
                is_clipboard_visual_line = false;
            }
            return false;
        case VIM_W:
            if (record->event.pressed) {
                if (d_pending) {
                    if (is_visual_mode) {
                        SEND_STRING(SS_UP(X_LSFT));
                        is_visual_mode = false;
                        is_visual_line_mode = false;
                    }
                    SEND_STRING(SS_DOWN(X_LSFT) SS_LCTL(SS_TAP(X_RIGHT)) SS_UP(X_LSFT) SS_LCTL("x"));
                    is_clipboard_visual_line = false;
                    d_pending = false;
                } else if (y_pending) {
                    if (is_visual_mode) {
                        SEND_STRING(SS_UP(X_LSFT));
                        is_visual_mode = false;
                        is_visual_line_mode = false;
                    }
                    SEND_STRING(SS_DOWN(X_LSFT) SS_LCTL(SS_TAP(X_RIGHT)) SS_UP(X_LSFT) SS_LCTL("c") SS_TAP(X_LEFT));
                    is_clipboard_visual_line = false;
                    y_pending = false;
                } else {
                    SEND_STRING(SS_LCTL(SS_TAP(X_RIGHT)));
                }
            }
            return false;
        case VIM_B:
            if (record->event.pressed) {
                if (d_pending) {
                    if (is_visual_mode) {
                        SEND_STRING(SS_UP(X_LSFT));
                        is_visual_mode = false;
                        is_visual_line_mode = false;
                    }
                    SEND_STRING(SS_DOWN(X_LSFT) SS_LCTL(SS_TAP(X_LEFT)) SS_UP(X_LSFT) SS_LCTL("x"));
                    is_clipboard_visual_line = false;
                    d_pending = false;
                } else if (y_pending) {
                    if (is_visual_mode) {
                        SEND_STRING(SS_UP(X_LSFT));
                        is_visual_mode = false;
                        is_visual_line_mode = false;
                    }
                    SEND_STRING(SS_DOWN(X_LSFT) SS_LCTL(SS_TAP(X_LEFT)) SS_UP(X_LSFT) SS_LCTL("c") SS_TAP(X_RIGHT));
                    is_clipboard_visual_line = false;
                    y_pending = false;
                } else {
                    SEND_STRING(SS_LCTL(SS_TAP(X_LEFT)));
                }
            }
            return false;
    }
    return true;
}

#ifdef OLED_ENABLE
#include "lib/oledkit/oledkit.h"
void oledkit_render_info_user(void) {
    keyball_oled_render_keyinfo();
    keyball_oled_render_ballinfo();
}
#endif

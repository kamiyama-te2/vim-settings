#include QMK_KEYBOARD_H
#include "quantum.h"

enum custom_keycodes {
    QUIT_VIM = SAFE_RANGE,
    VIM_A,
    VIM_O,
    VIM_SHIFT_A,
    VIM_SHIFT_I,
    VIM_SHIFT_O,
    VIM_U,
    VIM_X,
    VIM_V,
    VIM_SHIFT_V,
    VIM_ESC_VIS,
    VIM_Y,
    VIM_P,
    VIM_SHIFT_P,
    VIM_SHIFT_G,
    VIM_W,
    VIM_B,
    VIM_J,
    VIM_K,
};

static uint8_t vs;
static uint16_t rt;
static uint8_t rk;

enum tap_dance_keycodes {
    VIM_DD,
    VIM_YY,
    VIM_GG,
    VIM_D_COMBO,
    VIM_Y_COMBO,
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [0] = LAYOUT_universal(
        KC_TAB,    KC_Q,     KC_W,     KC_E,     KC_R,     KC_T,     KC_Y,     KC_U,     KC_I,     KC_O,     KC_P,     KC_BSPC,
        KC_LSFT,   KC_A,     KC_S,     KC_D,     KC_F,     KC_G,     KC_H,     KC_J,     KC_K,     KC_L,     KC_MINS,  KC_ENT,
        KC_LCTL,  KC_Z,     KC_X,     KC_C,     KC_V,     KC_B,     KC_N,     KC_M,     KC_BTN1,  KC_BTN2,  MO(3),    TO(3),
                            KC_F4,  KC_LALT,  LT(1,KC_LNG1), KC_SPC, KC_DEL,   KC_ESC,   LT(2,KC_ENT), KC_LCTL, KC_LGUI,  KC_RALT
    ),
    [1] = LAYOUT_universal(
        TO(0),    _______,  S(KC_7),  S(KC_MINS), KC_MINS,  S(KC_DOT), S(KC_DOT), S(KC_1),  S(KC_6),  S(KC_EQL), _______, _______,
        _______,  _______,  S(KC_4),  S(KC_5),   S(KC_6),  KC_0,      KC_1,      KC_EQL,   KC_MINS,  S(KC_7),   _______, _______,
        _______,  _______,  S(KC_1),  S(KC_2),   S(KC_3),  S(KC_SLSH), KC_BSLS,  S(KC_SLSH), _______, _______, _______, _______,
                            _______,  _______,  _______,  _______,   _______,  _______,   _______,   _______,  _______,  _______
    ),
    [2] = LAYOUT_universal(
        TO(0),    _______,  KC_7,     KC_8,     KC_9,     S(KC_9),   S(KC_0),   KC_F7,    KC_F8,    KC_F9,    KC_F10,   _______,
        _______,  _______,  KC_4,     KC_5,     KC_6,     KC_LBRC,   KC_RBRC,   KC_F4,    KC_F5,    KC_F6,    KC_F11,   _______,
        _______,  _______,  KC_1,     KC_2,     KC_3,     S(KC_LBRC), S(KC_RBRC), KC_F1,   KC_F2,    KC_F3,    KC_F12,   _______,
                            KC_0,     KC_DOT,   _______,  _______,  _______,  _______,   _______,   _______,  _______,  _______
    ),
    [3] = LAYOUT_universal(
        QUIT_VIM, _______,  VIM_W,    _______,  _______,  _______,   TD(VIM_Y_COMBO), VIM_U, QUIT_VIM, VIM_O,    VIM_P,    _______,
        _______,  VIM_A,    _______,  TD(VIM_D_COMBO), _______, TD(VIM_GG), KC_LEFT, VIM_J,   VIM_K,    KC_RGHT,  _______,  _______,
        _______,  _______,  VIM_X,    _______,  VIM_V,    VIM_B,     _______,   _______,  _______,  _______,  _______,  _______,
                            _______,  _______,  _______,  _______,  _______,  KC_ESC,    _______,   _______,  _______,  _______
    ),
    [4] = LAYOUT_universal(
        _______,  _______,  _______,  _______,  _______,  _______,   _______,   _______,  VIM_SHIFT_I, VIM_SHIFT_O, VIM_SHIFT_P, _______,
        _______,  VIM_SHIFT_A, _______, _______, _______,  VIM_SHIFT_G, KC_LEFT, VIM_J,   VIM_K,    KC_RGHT,  _______,  _______,
        _______,  _______,  _______,  _______,  VIM_SHIFT_V, VIM_B,  _______,   _______,  _______,  _______,  _______,  _______,
                            _______,  _______,  _______,  _______,  _______,  KC_ESC,    _______,   _______,  _______,  _______
    ),
    [5] = LAYOUT_universal(
        VIM_ESC_VIS, _______, VIM_W,   _______,  _______,  _______,   TD(VIM_Y_COMBO), _______, VIM_SHIFT_I, VIM_SHIFT_O, _______, _______,
        _______,  KC_NO,    _______,  TD(VIM_D_COMBO), _______, VIM_SHIFT_G, KC_LEFT, VIM_J,   VIM_K,    KC_RGHT,  _______,  _______,
        _______,  _______,  VIM_X,    _______,  _______,  VIM_B,     _______,   _______,  _______,  _______,  _______,  _______,
                            _______,  _______,  _______,  _______,  _______,  VIM_ESC_VIS, _______,  VIM_ESC_VIS, _______, _______
    ),
};

layer_state_t layer_state_set_user(layer_state_t state) {
    keyball_set_scroll_mode(get_highest_layer(state) == 3);
    return state;
}

void matrix_scan_user(void) {
    if (rt && timer_elapsed(rt) > 75) {
        if (rk) {
            if (vs & 1) {
                if (!(vs & 32)) {
                    SEND_STRING(SS_DOWN(X_LSFT));
                    vs |= 32;
                }
                if (rk == 1)
                    SEND_STRING(SS_LCTL(SS_TAP(X_RIGHT)));
                else
                    SEND_STRING(SS_LCTL(SS_TAP(X_LEFT)));
            } else {
                if (rk == 1)
                    SEND_STRING(SS_LCTL(SS_TAP(X_RIGHT)));
                else
                    SEND_STRING(SS_LCTL(SS_TAP(X_LEFT)));
            }
            rt = timer_read();
        }
    }
}

void vim_dd(tap_dance_state_t *s, void *u) {
    if (s->count == 2) {
        SEND_STRING(SS_TAP(X_HOME) SS_DOWN(X_LSFT) SS_TAP(X_END) SS_UP(X_LSFT) SS_LCTL("x") SS_TAP(X_HOME) SS_TAP(X_BSPC));
        vs |= 4;
    }
}

void vim_yy(tap_dance_state_t *s, void *u) {
    if (s->count == 1) {
        if (vs & 1) {
            SEND_STRING(SS_LCTL("c"));
            if (vs & 32) {
                SEND_STRING(SS_UP(X_LSFT));
                vs &= ~32;
            }
            SEND_STRING(SS_TAP(X_LEFT));
            if (vs & 2)
                vs |= 4;
            vs &= ~3;
            layer_off(5);
        } else {
            vs |= 16;
        }
    } else if (s->count == 2) {
        SEND_STRING(SS_TAP(X_HOME) SS_DOWN(X_LSFT) SS_TAP(X_END) SS_UP(X_LSFT) SS_LCTL("c") SS_TAP(X_HOME));
        vs |= 4;
        vs &= ~16;
    }
}

void vim_gg(tap_dance_state_t *s, void *u) {
    if (s->count == 2) {
        if (vs & 1) {
            if (!(vs & 32)) {
                SEND_STRING(SS_DOWN(X_LSFT));
                vs |= 32;
            }
            if (vs & 2)
                SEND_STRING(SS_LCTL(SS_TAP(X_HOME)) SS_TAP(X_END));
            else
                SEND_STRING(SS_LCTL(SS_TAP(X_HOME)));
        } else {
            SEND_STRING(SS_LCTL(SS_TAP(X_HOME)));
        }
    }
}

void vim_d_combo(tap_dance_state_t *s, void *u) {
    if (s->count == 1) {
        if (vs & 1) {
            SEND_STRING(SS_LCTL("x"));
            if (vs & 32) {
                SEND_STRING(SS_UP(X_LSFT));
                vs &= ~32;
            }
            if (vs & 2)
                vs |= 4;
            vs &= ~3;
            layer_off(5);
        } else {
            vs |= 8;
        }
    } else if (s->count == 2) {
        SEND_STRING(SS_TAP(X_HOME) SS_DOWN(X_LSFT) SS_TAP(X_END) SS_UP(X_LSFT) SS_LCTL("x") SS_TAP(X_HOME) SS_TAP(X_BSPC));
        vs |= 4;
        vs &= ~8;
    }
}

void vim_y_combo(tap_dance_state_t *s, void *u) {
    vim_yy(s, u);
}

tap_dance_action_t tap_dance_actions[] = {
    [VIM_DD] = ACTION_TAP_DANCE_FN(vim_dd),
    [VIM_YY] = ACTION_TAP_DANCE_FN(vim_yy),
    [VIM_GG] = ACTION_TAP_DANCE_FN(vim_gg),
    [VIM_D_COMBO] = ACTION_TAP_DANCE_FN(vim_d_combo),
    [VIM_Y_COMBO] = ACTION_TAP_DANCE_FN(vim_y_combo),
};

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    if ((vs & 1) && !(vs & 2)) {
        switch (keycode) {
            case KC_LEFT:
            case KC_DOWN:
            case KC_UP:
            case KC_RGHT:
            case VIM_J:
            case VIM_K:
                if (!(vs & 32)) {
                    SEND_STRING(SS_DOWN(X_LSFT));
                    vs |= 32;
                }
                return true;
        }
    }

    if ((vs & 1) && (vs & 2)) {
        switch (keycode) {
            case KC_DOWN:
            case VIM_J:
                if (!(vs & 32)) {
                    SEND_STRING(SS_DOWN(X_LSFT));
                    vs |= 32;
                }
                SEND_STRING(SS_TAP(X_DOWN) SS_TAP(X_END));
                return false;
            case KC_UP:
            case VIM_K:
                if (!(vs & 32)) {
                    SEND_STRING(SS_DOWN(X_LSFT));
                    vs |= 32;
                }
                SEND_STRING(SS_TAP(X_UP) SS_TAP(X_HOME));
                return false;
            case KC_LEFT:
            case KC_RGHT:
                return false;
        }
    }

    switch (keycode) {
        case QUIT_VIM:
            vs &= ~15;
            if (vs & 32) {
                SEND_STRING(SS_UP(X_LSFT));
                vs &= ~32;
            }
            layer_clear();
            layer_on(0);
            rt = 0;
            return false;

        case VIM_A:
            SEND_STRING(SS_TAP(X_RIGHT));
            vs &= ~15;
            if (vs & 32) {
                SEND_STRING(SS_UP(X_LSFT));
                vs &= ~32;
            }
            layer_clear();
            layer_on(0);
            return false;

        case VIM_SHIFT_A:
            SEND_STRING(SS_TAP(X_END));
            vs &= ~15;
            if (vs & 32) {
                SEND_STRING(SS_UP(X_LSFT));
                vs &= ~32;
            }
            layer_clear();
            layer_on(0);
            return false;

        case VIM_O:
            if (record->event.pressed) {
                SEND_STRING(SS_TAP(X_END) SS_TAP(X_ENTER));
                vs &= ~15;
                if (vs & 32) {
                    SEND_STRING(SS_UP(X_LSFT));
                    vs &= ~32;
                }
                layer_clear();
                layer_on(0);
            }
            return false;

        case VIM_SHIFT_O:
            if (record->event.pressed) {
                SEND_STRING(SS_TAP(X_HOME) SS_TAP(X_ENTER) SS_TAP(X_UP));
                vs &= ~15;
                if (vs & 32) {
                    SEND_STRING(SS_UP(X_LSFT));
                    vs &= ~32;
                }
                layer_clear();
                layer_on(0);
            }
            return false;

        case VIM_SHIFT_I:
            SEND_STRING(SS_TAP(X_HOME));
            vs &= ~15;
            if (vs & 32) {
                SEND_STRING(SS_UP(X_LSFT));
                vs &= ~32;
            }
            layer_clear();
            layer_on(0);
            return false;

        case VIM_J:
            if (record->event.pressed) {
                if (vs & 1) {
                    if (!(vs & 32)) {
                        SEND_STRING(SS_DOWN(X_LSFT));
                        vs |= 32;
                    }
                    SEND_STRING(SS_TAP(X_DOWN));
                    if (vs & 2)
                        SEND_STRING(SS_TAP(X_END));
                } else {
                    SEND_STRING(SS_TAP(X_DOWN));
                }
            }
            return false;

        case VIM_K:
            if (record->event.pressed) {
                if (vs & 1) {
                    if (!(vs & 32)) {
                        SEND_STRING(SS_DOWN(X_LSFT));
                        vs |= 32;
                    }
                    SEND_STRING(SS_TAP(X_UP));
                    if (vs & 2)
                        SEND_STRING(SS_TAP(X_HOME));
                } else {
                    SEND_STRING(SS_TAP(X_UP));
                }
            }
            return false;

        case VIM_SHIFT_G:
            if ((vs & 1) && (vs & 2)) {
                if (!(vs & 32)) {
                    SEND_STRING(SS_DOWN(X_LSFT));
                    vs |= 32;
                }
                SEND_STRING(SS_LCTL(SS_TAP(X_END)) SS_TAP(X_END));
            } else if (vs & 1) {
                if (!(vs & 32)) {
                    SEND_STRING(SS_DOWN(X_LSFT));
                    vs |= 32;
                }
                SEND_STRING(SS_LCTL(SS_TAP(X_END)));
            } else {
                SEND_STRING(SS_LCTL(SS_TAP(X_END)));
            }
            return false;

        case VIM_P:
            if (record->event.pressed) {
                if (vs & 4)
                    SEND_STRING(SS_TAP(X_END) SS_TAP(X_ENTER) SS_LCTL("v"));
                else
                    SEND_STRING(SS_TAP(X_RIGHT) SS_LCTL("v"));
            }
            return false;

        case VIM_SHIFT_P:
            if (record->event.pressed) {
                if (vs & 4)
                    SEND_STRING(SS_TAP(X_HOME) SS_TAP(X_ENTER) SS_TAP(X_UP) SS_LCTL("v"));
                else
                    SEND_STRING(SS_LCTL("v"));
            }
            return false;

        case VIM_U:
            if (record->event.pressed)
                SEND_STRING(SS_LCTL("z"));
            return false;

        case VIM_V:
            if (record->event.pressed) {
                vs = (vs & ~24) | 1;
                layer_on(5);
                SEND_STRING(SS_DOWN(X_LSFT) SS_TAP(X_RIGHT));
                vs |= 32;
            }
            return false;

        case VIM_SHIFT_V:
            if (record->event.pressed) {
                vs = (vs & ~24) | 3;
                layer_on(5);
                SEND_STRING(SS_TAP(X_HOME) SS_DOWN(X_LSFT) SS_TAP(X_END));
                vs |= 32;
            }
            return false;

        case VIM_ESC_VIS:
            if (vs & 1) {
                if (vs & 32) {
                    SEND_STRING(SS_UP(X_LSFT));
                    vs &= ~32;
                }
                SEND_STRING(SS_TAP(X_LEFT));
                vs &= ~3;
                layer_off(5);
            }
            vs &= ~24;
            rt = 0;
            return false;

        case VIM_X:
            if (record->event.pressed) {
                if (vs & 1) {
                    SEND_STRING(SS_LCTL("x"));
                    if (vs & 32) {
                        SEND_STRING(SS_UP(X_LSFT));
                        vs &= ~32;
                    }
                    if (vs & 2)
                        vs |= 4;
                    else
                        vs &= ~4;
                    vs &= ~3;
                    layer_off(5);
                } else {
                    SEND_STRING(SS_DOWN(X_LSFT) SS_TAP(X_RIGHT) SS_UP(X_LSFT) SS_LCTL("x"));
                    vs &= ~4;
                }
            }
            return false;

        case VIM_Y:
            if (record->event.pressed) {
                if (vs & 1) {
                    SEND_STRING(SS_LCTL("c"));
                    if (vs & 32) {
                        SEND_STRING(SS_UP(X_LSFT));
                        vs &= ~32;
                    }
                    SEND_STRING(SS_TAP(X_LEFT));
                    if (vs & 2)
                        vs |= 4;
                    else
                        vs &= ~4;
                    vs &= ~3;
                    layer_off(5);
                } else {
                    vs |= 16;
                }
            }
            return false;

        case VIM_W:
            if (record->event.pressed) {
                if (vs & 8) {
                    SEND_STRING(SS_DOWN(X_LSFT) SS_LCTL(SS_TAP(X_RIGHT)) SS_UP(X_LSFT) SS_LCTL("x"));
                    vs &= ~12;
                } else if (vs & 16) {
                    SEND_STRING(SS_DOWN(X_LSFT) SS_LCTL(SS_TAP(X_RIGHT)) SS_UP(X_LSFT) SS_LCTL("c") SS_TAP(X_LEFT));
                    vs &= ~20;
                } else {
                    if (vs & 1) {
                        if (!(vs & 32)) {
                            SEND_STRING(SS_DOWN(X_LSFT));
                            vs |= 32;
                        }
                    }
                    SEND_STRING(SS_LCTL(SS_TAP(X_RIGHT)));
                    rt = timer_read();
                    rk = 1;
                }
            } else {
                rt = 0;
            }
            return false;

        case VIM_B:
            if (record->event.pressed) {
                if (vs & 8) {
                    SEND_STRING(SS_DOWN(X_LSFT) SS_LCTL(SS_TAP(X_LEFT)) SS_UP(X_LSFT) SS_LCTL("x"));
                    vs &= ~12;
                } else if (vs & 16) {
                    SEND_STRING(SS_DOWN(X_LSFT) SS_LCTL(SS_TAP(X_LEFT)) SS_UP(X_LSFT) SS_LCTL("c") SS_TAP(X_RIGHT));
                    vs &= ~20;
                } else {
                    if (vs & 1) {
                        if (!(vs & 32)) {
                            SEND_STRING(SS_DOWN(X_LSFT));
                            vs |= 32;
                        }
                    }
                    SEND_STRING(SS_LCTL(SS_TAP(X_LEFT)));
                    rt = timer_read();
                    rk = 2;
                }
            } else {
                rt = 0;
            }
            return false;

        default:
            return true;
    }
    return false;
}

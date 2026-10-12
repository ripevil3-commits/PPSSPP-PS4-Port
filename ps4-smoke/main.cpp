// Project-owned SDL2/PS4 toolchain probe.
// This validates that code maintained in this repository can compile and link
// against the OpenOrbis sample environment. It is not the PPSSPP frontend.
#include <SDL2/SDL.h>

int main(int, char **) {
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        return 1;
    }

    SDL_Window *window = SDL_CreateWindow(
        "PPSSPP PS4 Port - SDL2 probe",
        SDL_WINDOWPOS_UNDEFINED,
        SDL_WINDOWPOS_UNDEFINED,
        640,
        360,
        SDL_WINDOW_SHOWN
    );

    if (window == nullptr) {
        SDL_Quit();
        return 2;
    }

    SDL_Surface *surface = SDL_GetWindowSurface(window);
    if (surface == nullptr) {
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 3;
    }

    SDL_FillRect(surface, nullptr, SDL_MapRGB(surface->format, 28, 36, 52));
    SDL_UpdateWindowSurface(window);

    // CI only compiles and links this probe; runtime validation is a separate step.
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}

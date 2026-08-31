#include <stdbool.h>
#include <stdio.h>

// Comment
/*
Mutli-line
comment
*/

typedef struct {
    const char *name;
    int count;
    bool enabled;
} item_t;

static int clamp(int value, int low, int high) {
    if (value < low) {
        return low;
    }
    return value > high ? high : value;
}

int main(void) {
    item_t item = {"c-fixture", 9, true};
    int values[] = {1, 4, 9};
    size_t index = 0;

    while (index < sizeof(values) / sizeof(values[0])) {
        printf("%s %d %d\n", item.name, (int)index, clamp(values[index], 0, 5));
        index++;
    }

    return item.enabled ? 0 : 1;
}

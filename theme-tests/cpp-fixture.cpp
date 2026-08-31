#include <array>
#include <iostream>
#include <string>

// Comment
/*
Mutli-line
comment
*/

class Counter {
  public:
    Counter(std::string name, int start) : name_(std::move(name)), value_(start) {}

    void bump(int delta) { value_ += delta; }
    std::string label() const { return name_ + ":" + std::to_string(value_); }

  private:
    std::string name_;
    int value_;
};

int main() {
    Counter counter{"cpp", 5};
    std::array<int, 3> steps{1, 2, 3};
    for (const auto step : steps) {
        counter.bump(step);
    }
    std::cout << counter.label() << std::endl;
    return 0;
}

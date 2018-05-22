template <typename T>
class TM_average {
  public:
    TM_average();
    void sample(T val);
    double mean();
  private:
    double sum;
    int count;
};

template <typename T>
TM_average<T>::TM_average() {
  sum = 0;
  count = 0;
}

template <typename T>
void TM_average<T>::sample(T val) {
  sum += val;
  ++count;
}

template <typename T>
double TM_average<T>::mean() {
  double avg = count ? (sum/count) : 999999.;
  sum = 0.;
  count = 0;
  return avg;
}

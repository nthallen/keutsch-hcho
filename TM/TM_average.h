#ifndef TM_AVERAGE_INCLUDED
#define TM_AVERAGE_INCLUDED

template <typename T>
class TM_average {
  public:
    TM_average();
    void operator()(T sample);
    double operator()();
  private:
    double sum;
    int n_samples;
};

template <typename T>
TM_average<T>::TM_average() {
  n_samples = 0;
  sum = 0;
}

template <typename T>
void TM_average<T>::operator()(T sample) {
  sum += sample;
  ++n_samples;
}

template <typename T>
double TM_average<T>::operator()() {
  double mean = n_samples ? sum/n_samples : -1;
  sum = 0;
  n_samples = 0;
  return mean;
}
#endif

#include <algorithm>
#include <iostream>
#include <fstream>
#include <numeric>
#include <vector>
#include <string>

int main()
{
    std::vector<double> y;
    std::vector<double> x;
    
    char c;  // commas
    int  s;  // first row
    double temp1; double temp2;
    
    std::cout << "Dataset: " ;
    std::string userinput;
    std::cin >> userinput;

    std::string filename(".csv");
    filename = userinput + filename;
    
    std::ifstream file(filename);
    
    file.ignore ( std::numeric_limits<std::streamsize>::max(), '\n' );
    
    while (file >> s >> c >> temp1 >> c >> temp2) {
        y.push_back(temp1);
        x.push_back(temp2);
    }
    
    const auto n    = x.size();
    const auto x_bar  = std::accumulate(x.begin(), x.end(), 0.0)/n;
    const auto y_bar  = std::accumulate(y.begin(), y.end(), 0.0)/n;
    
    const auto xx_inner = std::inner_product(x.begin(), x.end(), x.begin(), 0.0);
    const auto xy_inner = std::inner_product(x.begin(), x.end(), y.begin(), 0.0);
    const auto yy_inner = std::inner_product(y.begin(), y.end(), y.begin(), 0.0);
    
    const auto s_xx = xx_inner - n*x_bar*x_bar;
    const auto s_xy = xy_inner - n*x_bar*y_bar;
    const auto s_yy = yy_inner - n*y_bar*y_bar;
    
    const auto slope     = s_xy/s_xx;
    const auto intercept = y_bar - slope * x_bar ;
    const auto SSR       = slope * s_xy;
    const auto SSE       = s_yy - SSR;

    std::cout << "yhat\t\t = " << intercept << " + " << slope << "x\n";
    std::cout << "F\t\t = " << SSR/(SSE/(n-2)) << "\n";
    std::cout << "Rsquared\t = " << SSR/(SSE+SSR) << "\n";
    
    return 0;
}

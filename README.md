<!-- PROJECT SHEILDS 
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
-->

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="">
    <img src="images/zero.png">
  </a>
</p>

## Algorithmic trading

This project seeks to build an algorithmic trading robot to trade shares on the
ASX.

### Brokerage

The nominated broker is Interactive Brokers

### Hardware

R scripts need reliable hardware to run, preferably Linux.

A Google Cloud server is probably a good option.

### Software

#### R

Obviously, using R, so install both **R** and **RStudio Server** (Open Source Edition) onto the server.

The following R packages are needed:

* IBrokers
* tidyverse

#### Ubuntu Desktop

The Interactive Brokers' trading software is required, but this requires a GUI.

Install Ubuntu GUI using Chrome Remote Desktop or VNC

#### Interactive Brokers' Trading Software

Lastly, download and install the IB trading software for access to the API capabilities.

*Note: IB's trading software shuts down daily. May need to write a bash script to open the program daily, or install IBcontrller.*

<!-- UPDATES -->
## Updates

### 30 September, 2019

The project is new. Nothing to update at the moment.


<!-- CONTRIBUTORS -->
## Contributors


<!-- CONTRIBUTING -->
## Contributing

Trello is being used for managing this project. You can contribute there.

For technical contributions:

1. Fork the Project
2. Create a new branch for your feature
3. Commit your changes
4. Push to the branch
5. Open a pull request

<!-- CONTACT -->
## Contact

<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=flat-square
[contributors-url]: https://github.com/AndrewManHayChiu/stocks/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=flat-square
[forks-url]: https://github.com/AndrewManHayChiu/stocks/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=flat-square
[stars-url]: https://github.com/AndrewManHayChiu/stocks/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=flat-square
[issues-url]: https://github.com/AndrewManHayChiu/stocks/issues
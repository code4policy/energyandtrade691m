// JavaScript to handle dynamic image cycling
document.addEventListener('DOMContentLoaded', function () {
    const sections = document.querySelectorAll('section');
    const navLinks = document.querySelectorAll('nav a');

    // Hide all sections except for petroleum by default
    sections.forEach(section => section.style.display = 'none');
    document.querySelector('#petroleum').style.display = 'block';

    // Navigation click functionality
    navLinks.forEach(link => {
        link.addEventListener('click', function (event) {
            event.preventDefault();
            sections.forEach(section => section.style.display = 'none');
            document.querySelector(this.getAttribute('href')).style.display = 'block';
        });
    });

    // Dynamic image update for each energy section
    const energySources = [
        { id: 'petroleum', folder: 'petroleum', prefix: 'petroleum_trade' },
        { id: 'coal', folder: 'coal', prefix: 'coal_trade' },
        { id: 'natural-gas', folder: 'natural_gas', prefix: 'gas_trade' },
        { id: 'nuclear', folder: 'nuclear', prefix: 'nuclear_trade' },
        { id: 'wind', folder: 'wind', prefix: 'wind_trade' },
        { id: 'hydropower', folder: 'hydropower', prefix: 'hydro_trade' },
        { id: 'solar', folder: 'solar', prefix: 'solar_trade' },
        { id: 'biomass', folder: 'biomass', prefix: 'biomass_trade' },
    ];

    const startYear = 1990;
    const endYear = 2024;

    energySources.forEach(source => {
        const image = document.getElementById(`${source.id}-map`);
        const yearDisplay = document.getElementById(`${source.id}-year-display`);
        let currentYear = startYear; // Start year

        // Function to update the image and year display
        function updateImage() {
            image.src = `us_trade_${source.folder}/${source.prefix}_${currentYear}.png`;
            yearDisplay.textContent = `Year: ${currentYear}`;
        }

        // Automatically cycle through years at 1-second intervals
        function cycleImages() {
            setInterval(() => {
                currentYear = currentYear === endYear ? startYear : currentYear + 1;
                updateImage();
            }, 1000); // 1-second interval
        }

        if (image) {
            updateImage(); // Initial image setup
            cycleImages(); // Start cycling images
        }
    });
});
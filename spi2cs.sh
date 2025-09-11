SPI=$(./findspi.sh)
echo SPI=$SPI
echo 0 > /sys/class/spi_master/$SPI/delete_device # CS0
echo 1 > /sys/class/spi_master/$SPI/delete_device # CS1
sudo rmmod gpio_ch341 i2c_ch341 ch341_core spi_ch341 
sudo insmod ./ch341-core.ko && sudo insmod ./spi-ch341.ko && sudo insmod ./i2c-ch341.ko && sudo insmod ./gpio-ch341.ko
echo "spidev 0" > /sys/class/spi_master/$SPI/new_device
echo "spidev 1" > /sys/class/spi_master/$SPI/new_device
echo spidev > /sys/bus/spi/devices/${SPI}.0/driver_override
echo spidev > /sys/bus/spi/devices/${SPI}.1/driver_override
echo spi4.0 > /sys/bus/spi/drivers/spidev/bind
echo spi4.1 > /sys/bus/spi/drivers/spidev/bind
gpioinfo gpiochip4
i2cdetect -l

ls -la /sys/class/spi_master/*
ls -la /sys/bus/spi/devices/spi*

CROSS_COMPILE ?= arm-none-eabi-
CC := $(CROSS_COMPILE)gcc
AR := $(CROSS_COMPILE)ar
OBJCOPY := $(CROSS_COMPILE)objcopy

CFLAGS := -Wall -mthumb -mcpu=cortex-m0 --specs=nosys.specs -Ilib/inc -Isrc -IFreeRTOS/include -IFreeRTOS/portable -DUSE_STDPERIPH_DRIVER -DSTM32F030
LDFLAGS := -nostartfiles -mcpu=cortex-m0 -Tlib/stm32_flash.ld

all: stm32f0xx.bin stm32f0xx.hex

stm32f0xx.bin: stm32f0xx.elf
	$(OBJCOPY) -O binary $< $@

stm32f0xx.elf: src/startup_stm32f0xx.o src/system_stm32f0xx.o src/led.o src/main.o lib/src/libstm32f0xx.a FreeRTOS/libFreeRTOS.a
	$(CC) -o $@ $^ $(LDFLAGS)

stm32f0xx.hex: stm32f0xx.elf
	$(OBJCOPY) -O ihex $< $@

lib/src/libstm32f0xx.a: lib/src/stm32f0xx_adc.o lib/src/stm32f0xx_can.o lib/src/stm32f0xx_cec.o \
	lib/src/stm32f0xx_comp.o lib/src/stm32f0xx_crc.o lib/src/stm32f0xx_crs.o lib/src/stm32f0xx_dac.o \
	lib/src/stm32f0xx_dbgmcu.o lib/src/stm32f0xx_dma.o lib/src/stm32f0xx_exti.o lib/src/stm32f0xx_flash.o \
	lib/src/stm32f0xx_gpio.o lib/src/stm32f0xx_i2c.o lib/src/stm32f0xx_iwdg.o lib/src/stm32f0xx_misc.o \
	lib/src/stm32f0xx_pwr.o lib/src/stm32f0xx_rcc.o lib/src/stm32f0xx_rtc.o lib/src/stm32f0xx_spi.o \
	lib/src/stm32f0xx_syscfg.o lib/src/stm32f0xx_tim.o lib/src/stm32f0xx_usart.o lib/src/stm32f0xx_wwdg.o
	$(AR) -crv $@ $^

FreeRTOS/libFreeRTOS.a: FreeRTOS/croutine.o FreeRTOS/event_groups.o FreeRTOS/list.o FreeRTOS/queue.o \
	FreeRTOS/stream_buffer.o FreeRTOS/tasks.o FreeRTOS/timers.o FreeRTOS/portable/port.o FreeRTOS/portable/heap_1.o \
	FreeRTOS/portable/heap_2.o FreeRTOS/portable/heap_3.o FreeRTOS/portable/heap_4.o FreeRTOS/portable/heap_5.o
	$(AR) -crv $@ $^

%.o: %.s
	$(CC) $(CFLAGS) -o $@ -c $<

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

.PHONY: clean
clean:
	rm -f lib/src/*.o lib/src/*.a
	rm -f FreeRTOS/*.o FreeRTOS/portable/*.o FreeRTOS/*.a
	rm -f src/*.o
	rm -f *.hex *.bin *.elf

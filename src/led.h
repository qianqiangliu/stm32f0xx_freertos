#ifndef _LED_H_
#define _LED_H_

#include <stdint.h>

#include "stm32f0xx_rcc.h"
#include "stm32f0xx_gpio.h"

#define LED_RCC	RCC_AHBPeriph_GPIOC
#define LED_PORT GPIOC
#define LED_PIN	GPIO_Pin_13

void led_init(void);
void led_on(GPIO_TypeDef *port, uint16_t pin);
void led_off(GPIO_TypeDef *port, uint16_t pin);
void led_toggle(GPIO_TypeDef *port, uint16_t pin);

#endif	/* _LED_H_ */

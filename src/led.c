#include "led.h"

void led_init(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	RCC_AHBPeriphClockCmd(LED_RCC, ENABLE);

	GPIO_InitStructure.GPIO_Pin   = LED_PIN;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
	GPIO_InitStructure.GPIO_Mode  = GPIO_Mode_OUT;
	GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
	GPIO_InitStructure.GPIO_PuPd  = GPIO_PuPd_UP;
	GPIO_Init(LED_PORT, &GPIO_InitStructure);
}

void led_on(GPIO_TypeDef *port, uint16_t pin)
{
	port->BSRR = pin;
}

void led_off(GPIO_TypeDef *port, uint16_t pin)
{
	port->BRR = pin;
}

void led_toggle(GPIO_TypeDef *port, uint16_t pin)
{
	if (port->ODR & pin)
		port->BRR = pin;
	else
		port->BSRR = pin;
}

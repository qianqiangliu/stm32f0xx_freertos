#include "FreeRTOS.h"
#include "task.h"

#include "led.h"

#define LED_TASK_STACK_SIZE		(configMINIMAL_STACK_SIZE + 16)
#define LED_TASK_PRIORITY		(tskIDLE_PRIORITY + 1)

static void led_task(void *args)
{
	TickType_t xPreviousWakeTime;

	xPreviousWakeTime = xTaskGetTickCount();
	for (;;) {
		led_toggle();
		vTaskDelayUntil(&xPreviousWakeTime, 1000 / portTICK_PERIOD_MS);
	}
}

int main()
{
	led_init();
	xTaskCreate(led_task, "led_task", LED_TASK_STACK_SIZE, NULL, LED_TASK_PRIORITY, NULL);
	vTaskStartScheduler();

	return 0;
}

void vApplicationMallocFailedHook( void )
{
	taskDISABLE_INTERRUPTS();
	for( ;; );
}

void vApplicationStackOverflowHook( TaskHandle_t pxTask, char *pcTaskName )
{
	taskDISABLE_INTERRUPTS();
	for( ;; );
}

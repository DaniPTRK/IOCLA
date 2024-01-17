// Ion Daniel 315CC
#include "operations.h"
#include "structs.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void adaugare_operatii(sensor *a, int k, FILE *f)
{
  /* In aceasta functie adaug operatiile citite din fisierul binar pentru
  fiecare senzor. */
  int j;
  fread(&(a[k].nr_operations), sizeof(int), 1, f);
  a[k].operations_idxs = (int *)malloc(a[k].nr_operations * sizeof(int));
  for (j = 0; j < a[k].nr_operations; j++) {
    fread(&(a[k].operations_idxs[j]), sizeof(int), 1, f);
  }
}

void printing(sensor *a, int index, int n)
{
  /*Aici se executa comanda print.
  Verific daca indexul se afla intre capete, intre 0 si n.*/
  if ((index < 0) || (index >= n)) {
    printf("Index not in range!\n");
  } else {
    /* Verific tipul de senzor si, in functie de acesta, realizez o afisare
    in conformitate cu cea data in cerinta.*/
    if (a[index].sensor_type == 0) {
      printf("Tire Sensor\n");
      printf("Pressure: %.2f\n",
	     ((tire_sensor *)a[index].sensor_data)->pressure);
      printf("Temperature: %.2f\n",
	     ((tire_sensor *)a[index].sensor_data)->temperature);
      printf("Wear Level: %d%%\n",
	     ((tire_sensor *)a[index].sensor_data)->wear_level);
      if (((tire_sensor *)a[index].sensor_data)->performace_score == 0) {
	printf("Performance Score: Not Calculated\n");
      } else {
	printf("Performance Score: %d\n",
	       ((tire_sensor *)a[index].sensor_data)->performace_score);
      }
    } else {
      printf("Power Management Unit\n");
      printf("Voltage: %.2f\n",
	     ((power_management_unit *)a[index].sensor_data)->voltage);
      printf("Current: %.2f\n",
	     ((power_management_unit *)a[index].sensor_data)->current);
      printf(
	  "Power Consumption: %.2f\n",
	  ((power_management_unit *)a[index].sensor_data)->power_consumption);
      printf("Energy Regen: %d%%\n",
	     ((power_management_unit *)a[index].sensor_data)->energy_regen);
      printf("Energy Storage: %d%%\n",
	     ((power_management_unit *)a[index].sensor_data)->energy_storage);
    }
  }
}

void analyzing(sensor *a, int index, int n, void (*operations[8])(void *))
{
  /*Aici se executa comanda analyze.
  Verific daca indexul se afla intre capete, intre 0 si n.*/
  int i;
  if ((index < 0) || (index >= n)) {
    printf("Index not in range!\n");
  } else {
    // Execut operatiile salvate in vectorul de functii operations.
    for (i = 0; i < a[index].nr_operations; i++) {
      (*operations[a[index].operations_idxs[i]])(a[index].sensor_data);
    }
  }
}

void cleaning(sensor *a, int *n)
{
  // Aici are loc executia comenzii clear.
  int i, j, ok;
  for (i = 0; i < (*n); i++) {
    ok = 0;
    /*Verific informatiile primite din fisierul binar in functie de tipul de
    senzor. In cazul in care informatiile nu se afla in parametrii dati, ok
    devine 1, iar senzorul este scos din vectorul de senzori.*/
    if (a[i].sensor_type == 0) {
      if ((((tire_sensor *)a[i].sensor_data)->pressure < 19) ||
	  (((tire_sensor *)a[i].sensor_data)->pressure > 28) ||
	  (((tire_sensor *)a[i].sensor_data)->temperature < 0) ||
	  (((tire_sensor *)a[i].sensor_data)->temperature > 120) ||
	  (((tire_sensor *)a[i].sensor_data)->wear_level < 0) ||
	  (((tire_sensor *)a[i].sensor_data)->wear_level > 100)) {
	ok = 1;
      }
    } else {
      if ((((power_management_unit *)a[i].sensor_data)->voltage < 10) ||
	  (((power_management_unit *)a[i].sensor_data)->voltage > 20) ||
	  (((power_management_unit *)a[i].sensor_data)->current < -100) ||
	  (((power_management_unit *)a[i].sensor_data)->current > 100) ||
	  (((power_management_unit *)a[i].sensor_data)->power_consumption <
	   0) ||
	  (((power_management_unit *)a[i].sensor_data)->power_consumption >
	   1000) ||
	  (((power_management_unit *)a[i].sensor_data)->energy_regen < 0) ||
	  (((power_management_unit *)a[i].sensor_data)->energy_regen > 100) ||
	  (((power_management_unit *)a[i].sensor_data)->energy_storage < 0) ||
	  (((power_management_unit *)a[i].sensor_data)->energy_storage > 100)) {
	ok = 1;
      }
    }
    if (ok == 1) {
      // Scot senzorul din vectorul de senzori.
      ok = 0;
      (*n)--;
      free(a[i].operations_idxs);
      free(a[i].sensor_data);
      for (j = i; j < (*n); j++) {
	a[j] = a[j + 1];
      }
      i--;
    }
  }
}

int main(int argc, char const *argv[])
{
  // Cateva initializari.
  FILE *f = fopen(argv[1], "rb");
  sensor *a, *b, *c;
  void **aux, (*oper[8])(void *);
  int n, i, k1 = 0, k2 = 0, tip, index;
  aux = (void **)malloc(8 * sizeof(void *));
  get_operations(aux);
  for (i = 0; i < 8; i++) {
    oper[i] = (void *)aux[i];
  }
  // Initializez vectorul de comenzi.
  char comenzi[4][8] = {"print", "analyze", "clear", "exit"}, comanda[8] = "a";
  fread(&n, sizeof(int), 1, f);
  // Aloc memorie si citesc vectorii de senzori.
  // a = vector tire_sensor
  // b = vector PMU
  // c = vectorul PMU + vectorul tire_sensor
  a = (sensor *)malloc(n * sizeof(sensor));
  b = (sensor *)malloc(n * sizeof(sensor));
  c = (sensor *)malloc(n * sizeof(sensor));
  for (i = 0; i < n; i++) {
    fread(&tip, sizeof(int), 1, f);
    if (tip == 0) {
      a[k1].sensor_type = 0;
      a[k1].sensor_data = (tire_sensor *)malloc(sizeof(tire_sensor));
      fread(&(((tire_sensor *)a[k1].sensor_data)->pressure), sizeof(float), 1,
	    f);
      fread(&(((tire_sensor *)a[k1].sensor_data)->temperature), sizeof(float),
	    1, f);
      fread(&(((tire_sensor *)a[k1].sensor_data)->wear_level), sizeof(int), 1,
	    f);
      fread(&(((tire_sensor *)a[k1].sensor_data)->performace_score),
	    sizeof(int), 1, f);
      adaugare_operatii(a, k1, f);
      k1++;
    } else {
      b[k2].sensor_type = 1;
      b[k2].sensor_data =
	  (power_management_unit *)malloc(sizeof(power_management_unit));
      fread(&(((power_management_unit *)b[k2].sensor_data)->voltage),
	    sizeof(float), 1, f);
      fread(&(((power_management_unit *)b[k2].sensor_data)->current),
	    sizeof(float), 1, f);
      fread(&(((power_management_unit *)b[k2].sensor_data)->power_consumption),
	    sizeof(float), 1, f);
      fread(&(((power_management_unit *)b[k2].sensor_data)->energy_regen),
	    sizeof(int), 1, f);
      fread(&(((power_management_unit *)b[k2].sensor_data)->energy_storage),
	    sizeof(int), 1, f);
      adaugare_operatii(b, k2, f);
      k2++;
    }
  }
  a = (sensor *)realloc(a, k1 * sizeof(sensor));
  b = (sensor *)realloc(b, k2 * sizeof(sensor));
  for (i = 0; i < n; i++) {
    if (i < k2) {
      c[i] = b[i];
    } else {
      c[i] = a[i - k2];
    }
  }
  // Se citesc si se executa comenzile primite pana cand se intalneste comanda
  // exit(comenzi[3]).
  while (strcmp(comanda, comenzi[3]) != 0) {
    scanf("%s", comanda);
    for (i = 0; i < 3; i++) {
      if (strcmp(comanda, comenzi[i]) == 0) {
	switch (i) {
	case 0: {
	  // Caz corespondent comenzii print.
	  scanf("%d", &index);
	  printing(c, index, n);
	  break;
	}
	case 1: {
	  // Caz corespondent comenzii analyze.
	  scanf("%d", &index);
	  analyzing(c, index, n, oper);
	  break;
	}
	case 2: {
	  // Caz corespondent comenzii clear.
	  cleaning(c, &n);
	  c = (sensor *)realloc(c, n * sizeof(sensor));
	  break;
	}
	}
      }
    }
  }
  // Dupa ce se executa comanda exit, dealoc toata memoria alocata.
  for (i = 0; i < n; i++) {
    free(c[i].operations_idxs);
    free(c[i].sensor_data);
  }
  free(aux);
  free(a);
  free(b);
  free(c);
  fclose(f);
  return 0;
}

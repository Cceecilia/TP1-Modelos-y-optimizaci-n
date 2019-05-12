/*********************************************
 * OPL 12.9.0.0 Model
 * Author: cecilia
 * Creation Date: 11 may. 2019 at 01:37:37
 *********************************************/

 // Constantes
 {int} PRODUCTOS = ...;
 int DISPONIBILIDAD[PRODUCTOS] = ...;
 int PRECIO_PROMO[PRODUCTOS] = ...;
 int PRECIO_REGULAR[PRODUCTOS] = ...;
 int PREFERENCIAS_PROMO[PRODUCTOS] = ...;
 int PREFERENCIAS_REGULAR[PRODUCTOS] = ...;
 int M = 100;
 
 // Variables bivalentes
 
 dvar int Ypref[PRODUCTOS] in 0..1;
 // Es 1 si el cliente prefiere el producto p antes que otros a precio regular, y 0 sino.
 dvar int Ypref_promo[PRODUCTOS] in 0..1;
 // Es 1 si el cliente prefiere el producto en promo p antes que otros, y 0 sino.
 
 dvar int Ycompra_regular[PRODUCTOS] in 0..1;
 // Es 1 si el cliente compra el producto p a precio regular, y 0 sino.
 dvar int Ycompra_promo[PRODUCTOS] in 0..1;
 // Es 1 si el cliente compra el producto p en promoción, y 0 sino.

 
 // Variables enteras
 dvar int Pref[PRODUCTOS]; // Orden de preferencia de un producto
 dvar int Orden_pref_cliente; // Número de preferencia del producto que el cliente compraría.
 dvar int Precio_pref_cliente; // Precio del producto que el cliente compraría.
 dvar int Producto_comprado;
 dvar int Precio_producto_comprado;
 
 
 // Objetivo
 maximize
   sum(p in PRODUCTOS) (PRECIO_REGULAR[p]*Ycompra_regular[p] + PRECIO_PROMO[p]*Ycompra_promo[p]); 
 
 // Modelo
 subject to { 
 
   forall(p in PRODUCTOS) {
      preferencias: Pref[p] - ( PREFERENCIAS_REGULAR[p]*DISPONIBILIDAD[p]+M*(1-DISPONIBILIDAD[p]) ) == 0;
   }
   
   ordenElegido: forall(p in PRODUCTOS) {
     Pref[p] - M*(1-Ypref[p]) <= Orden_pref_cliente;
     Orden_pref_cliente <= Pref[p];
   }      
   productoElegido: sum(p in PRODUCTOS) Ypref[p] - 1 == 0;
   precioElegido: Precio_pref_cliente - sum(p in PRODUCTOS) PRECIO_REGULAR[p]*Ypref[p] == 0;
   
   promosElegidas: forall(p in PRODUCTOS) {
     Ypref_promo[p]*PREFERENCIAS_PROMO[p] <= Orden_pref_cliente;
     Orden_pref_cliente <= PREFERENCIAS_PROMO[p] + M*Ypref_promo[p];   
   }
 
   forall(p in PRODUCTOS){
     compraRegular: Ycompra_regular[p] <= Ypref[p];
     compraPromo: Ycompra_promo[p] <= Ypref_promo[p];
     compraPromoDisponible: Ycompra_promo[p] <= DISPONIBILIDAD[p];   
   }
   compra1Producto: sum(p in PRODUCTOS) (Ycompra_regular[p] + Ycompra_promo[p]) -1 == 0;
 
   Producto_comprado - sum(p in PRODUCTOS) p*(Ycompra_regular[p]+Ycompra_promo[p]) == 0;
   Precio_producto_comprado - sum(p in PRODUCTOS) (PRECIO_REGULAR[p]*Ycompra_regular[p]+PRECIO_PROMO[p]*Ycompra_promo[p]) == 0;
 }
 
 execute{
   writeln("Producto"+Producto_comprado+"a precio"+Precio_producto_comprado);
 }
 
 
 
 
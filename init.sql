SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = ‘UTF8’;
SET standard_conforming_strings = on;

SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;
SET default_with_oids = false;

--schema: master
    --table: allergenName
    --table: cuisineName
    --table: processingName

CREATE SCHEMA IF NOT EXISTS "master";

CREATE TABLE IF NOT EXISTS master."allergenName"
(
    "id" integer NOT NULL,
    "name" text COLLATE pg_catalog."default" NOT NULL,
    "description" text COLLATE pg_catalog."default",
    CONSTRAINT "allergen_pkey" PRIMARY KEY (id),
    CONSTRAINT "allergen_name_key" UNIQUE (name)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS master."cuisineName"
(
    "id" integer NOT NULL,
    "name" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "cuisineName_pkey" PRIMARY KEY (id),
    CONSTRAINT "cuisineName_name_key" UNIQUE (name)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS master."processingName"
(
    "id" integer NOT NULL,
    "name" text COLLATE pg_catalog."default" NOT NULL,
    "description" text COLLATE pg_catalog."default",
    CONSTRAINT "processing_pkey" PRIMARY KEY (id),
    CONSTRAINT "processing_name_key" UNIQUE (name)
)
TABLESPACE pg_default;

--schema: inventory
    --table: supplier
    --table: supplierItem
    --table: bulkItem
    --table: bulkItemHistory
    --table: bulkWorkOrder
    --table: sachetItem
    --table: sachetItemHistory
    --table: sachetIWorkOrder
    --table: purchaseOrderItem 
    --table: unitConversionByBulkItem
  
CREATE SCHEMA IF NOT EXISTS "inventory"; --[AUTHORIISATION userName]

CREATE TABLE IF NOT EXISTS inventory."supplier"
( 
    "id" integer NOT NULL,
    "name" text COLLATE pg_catalog.default NOT NULL,
    "contactPerson" jsonb,
    "address" jsonb,
    "shippingTerms" jsonb,
    "paymentTerms" jsonb,
    "available" boolean NOT NULL DEFAULT true,
    CONSTRAINT "supplier_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS inventory."supplierItem"
(
    "id" integer NOT NULL,
    "name" text COLLATE pg_catalog.default NOT NULL,
    "unitSize" integer NOT NULL,
    "prices" jsonb,
    "processingAsShippedId" integer,
    "supplierId" integer,
    unit text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "supplierItem_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS inventory."bulkItem"
(
    "id" integer NOT NULL,
    "processingName" text COLLATE pg_catalog.default NOT NULL,
    "supplierItemId" integer NOT NULL,
    "labor" jsonb,
    "shelfLife" jsonb,
    "yield" jsonb,
    "nutritionInfo" jsonb,
    "sop" jsonb,
    "allergans" jsonb,
    "parLevel" numeric,
    "maxLevel" numeric,
    "onHand" numeric NOT NULL DEFAULT 0,
    "available" boolean NOT NULL DEFAULT true,
    "storageCondition" jsonb,
    "createdAt" timestamp with time zone DEFAULT now(),
    "updatedAt" timestamp with time zone DEFAULT now(),
    "image" text COLLATE pg_catalog.default,
    "bulkDensity" numeric DEFAULT 1,
    "equipments" jsonb,
    "unit" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "bulkInventoryItem_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS inventory."bulkItemHistory"
(
    "id" integer NOT NULL,
    "bulkItemId" integer NOT NULL,
    "quantity" numeric NOT NULL,
    "comment" jsonb NOT NULL,
    "purchaseOrderItemId" integer,
    "workOrderId" integer,
    "status" text COLLATE pg_catalog."default" NOT NULL,
    "unit" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "bulkHistory_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS inventory."bulkWorkOrder"
(
    "id" integer,
    "inputBulkItemId" integer NOT NULL,
    "outputBulkItemId" integer NOT NULL,
    "outputQuantity" numeric NOT NULL,
    "userId" integer,
    "scheduledOn" timestamp with time zone,
    "inputQuantity" numeric NOT NULL,
    "status" text COLLATE pg_catalog."default" NOT NULL,
    "stationId" integer,
    "inputQuantityUnit" text COLLATE pg_catalog."default",
    CONSTRAINT "bulkWorkOrder_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS inventory."sachetItem"
(
    "id" integer NOT NULL,
    "unitSize" numeric NOT NULL,
    "parLevel" integer,
    "maxLevel" integer,
    "onHand" integer NOT NULL DEFAULT 0,
    "available" boolean NOT NULL DEFAULT true,
    "bulkItemId" integer NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now(),
    "updatedAt" timestamp with time zone DEFAULT now(),
    "unit" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "sacheItem_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS inventory."sachetItemHistory"
(
    "id" integer NOT NULL,
    "sachetItemId" integer NOT NULL,
    "sachetWorkItemId" integer,
    "quantity" numeric NOT NULL,
    "comment" jsonb NOT NULL,
    "status" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "sachetHistory_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS inventory."sachetWorkOrder"
(
    "id" integer NOT NULL,
    "inputBulkItemId" integer NOT NULL,
    "outputSachetItemId" integer NOT NULL,
    "outputQuantity" numeric NOT NULL,
    "inputQuantity" numeric NOT NULL,
    "packagingId" integer,
    "label" jsonb,
    "stationId" integer,
    "userId" integer,
    "scheduledOn" timestamp with time zone,
    status text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "sachetWorkOrder_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS inventory."purchaseOrderItem"
(
    "id" integer NOT NULL,
    "bulkItemId" integer NOT NULL,
    "supplierItemId" integer NOT NULL,
    "orderQuantity" numeric NOT NULL,
    "status" text COLLATE pg_catalog."default" NOT NULL,
    "details" jsonb,
    "unit" text COLLATE pg_catalog."default" NOT NULL,
    "supplierId" integer NOT NULL,
    CONSTRAINT "purchaseOrder_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS inventory."unitConversionByBulkItem"
(
    "id" integer NOT NULL,
    "bulkItemId" integer NOT NULL,
    "unitConversionId" integer NOT NULL,
    "customConversionFactor" numeric NOT NULL,
    CONSTRAINT "unitConversionByBulkItem_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

--schema: ingredient
    --table: ingredient
    --table: ingredientProcessing
    --table: ingredientScahet
    --table: plannedMode
    --table: realTimeMode

CREATE SCHEMA IF NOT EXISTS "ingredient"; --[AUTHORISATION userName]

CREATE TABLE IF NOT EXISTS ingredient."ingredient"
(
    "id" integer NOT NULL,
    "name" text COLLATE pg_catalog."default" NOT NULL,
    "image" text COLLATE pg_catalog."default",
    "isValid" boolean NOT NULL DEFAULT false,
    "isPublished" boolean NOT NULL DEFAULT false,
    CONSTRAINT ingredient_pkey PRIMARY KEY (id),
    CONSTRAINT ingredient_name_key UNIQUE (name)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS ingredient."ingredientProcessing"
(
    "id" integer NOT NULL,
    "processingName" text COLLATE pg_catalog."default" NOT NULL,
    "ingredientId" integer NOT NULL,
    CONSTRAINT "ingredientProcessing_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS ingredient."ingredientSachet"
(
    "id" integer NOT NULL,
    "quantity" numeric NOT NULL,
    "ingredientProcessingId" integer NOT NULL,
    "ingredientId" integer NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now(),
    "updatedAt" timestamp with time zone DEFAULT now(),
    "tracking" boolean NOT NULL DEFAULT true,
    "unit" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "ingredientSachet_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS ingredient."plannedMode"
(
    "id" integer NOT NULL,
    "ingredientSachetId" integer NOT NULL,
    "active" boolean NOT NULL DEFAULT false,
    "sachetItemId" integer,
    "stationId" integer,
    CONSTRAINT "plannedMode_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS ingredient."realTimeMode"
(
    "id" integer NOT NULL,
    "ingredientSachetId" integer NOT NULL,
    "active" boolean NOT NULL DEFAULT false,
    "bulkItemId" integer NOT NULL,
    "stationId" integer,
    "packagingId" integer,
    CONSTRAINT "realTime_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

--schema: onlineStore
    --table: category
    --table: comboProduct
    --table: comboProductComponent
    --table: customizableProductOption
    --table: inventoryProduct
    --table: inventoryProductOption
    --table: menuCollection
    --table: simpleRecipeProduct
    --table: simpleRecipeProductOption

CREATE SCHEMA IF NOT EXISTS "onlineStore";

CREATE TABLE IF NOT EXISTS "onlineStore"."category"
(
    "id" integer NOT NULL,
    "name" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "category_pkey" PRIMARY KEY (id),
    CONSTRAINT "category_name_key" UNIQUE (name)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS "onlineStore"."comboProduct"
(
    "id" integer NOT NULL,
    "name" jsonb NOT NULL,
    CONSTRAINT "recipeProduct_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS "onlineStore"."comboProductComponent"
(
    "id" integer NOT NULL,
    "simpleRecipeProductId" integer,
    "inventoryProductId" integer,
    "customizableProductId" integer,
    "label" text COLLATE pg_catalog."default" NOT NULL,
    "comboProductId" integer NOT NULL,
    CONSTRAINT "comboProductComponents_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS "onlineStore"."customizableProduct"
(
    "id" integer NOT NULL,
    "name" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "smartProduct_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS "onlineStore"."customizableProductOption"
(
    "id" integer NOT NULL,
    "simpleRecipeProductId" integer,
    "inventoryProductId" integer,
    "customizableProductId" integer NOT NULL,
    "accompanients" jsonb,
    CONSTRAINT "customizableProductOptions_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS "onlineStore"."inventoryProduct"
(
    "id" integer NOT NULL,
    "supplierItemId" integer,
    "sachetItemId" integer,
    "accompanients" jsonb,
    CONSTRAINT "inventoryProduct_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS "onlineStore"."inventoryProductOption"
(
    "id" integer NOT NULL,
    "quantity" integer NOT NULL,
    "label" text COLLATE pg_catalog."default",
    "inventoryProductId" integer NOT NULL,
    "price" jsonb NOT NULL,
    CONSTRAINT "inventoryProductOption_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS "onlineStore"."menuCollection"
(
    "id" integer NOT NULL,
    "name" text COLLATE pg_catalog."default" NOT NULL,
    "availability" text COLLATE pg_catalog."default" NOT NULL,
    "active" boolean NOT NULL DEFAULT true,
    "categories" jsonb NOT NULL,
    CONSTRAINT "menuCollection_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS "onlineStore"."simpleRecipeProduct"
(
    "id" integer NOT NULL,
    "simpleRecipeId" integer NOT NULL,
    "name" text COLLATE pg_catalog."default" NOT NULL,
    "accompanients" jsonb,
    CONSTRAINT "simpleRecipeProduct_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS "onlineStore"."simpleRecipeProductOption"
(
    "id" integer NOT NULL,
    "recipeYieldId" integer NOT NULL,
    "simpleRecipeProductId" integer NOT NULL,
    "type" text COLLATE pg_catalog."default" NOT NULL,
    "price" jsonb NOT NULL,
    CONSTRAINT "simpleRecipeProductVariant_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

--schema: packaging
    --table: packaging

CREATE SCHEMA IF NOT EXISTS "packaging";

CREATE TABLE IF NOT EXISTS packaging."packaging"
(
    "id" integer NOT NULL,
    "name" text COLLATE pg_catalog."default" NOT NULL,
    "sku" text COLLATE pg_catalog."default" NOT NULL,
    "supplierId" integer NOT NULL,
    "unitPrice" numeric NOT NULL,
    "weight" numeric NOT NULL,
    "weightUnit" text COLLATE pg_catalog."default" NOT NULL,
    "volume" numeric NOT NULL,
    "volumeUnit" text COLLATE pg_catalog."default" NOT NULL,
    "parLevel" integer NOT NULL,
    "maxLevel" integer NOT NULL,
    "OnHand" integer NOT NULL,
    "unitWeight" numeric,
    CONSTRAINT "packaging_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

--schema: settings
    --table: station
    --table: settings

CREATE SCHEMA IF NOT EXISTS "settings";

CREATE TABLE IF NOT EXISTS settings."station"
(
    "id" integer NOT NULL,
    "name" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "station_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS settings."user"
(
    "id" integer NOT NULL,
    "firstName" text COLLATE pg_catalog."default" NOT NULL,
    "lastName" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "user_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

--schema: simpleRecipe
    --table: recipeYield_ingredientSachet
    --table: simpleRecipe
    --table: simpleRecipeYield

CREATE SCHEMA IF NOT EXISTS "simpleRecipe";

CREATE TABLE IF NOT EXISTS "simpleRecipe"."simpleRecipe"
(
    "id" integer NOT NULL,
    "author" text COLLATE pg_catalog."default",
    "name" jsonb NOT NULL,
    "procedures" jsonb,
    "assemblyStationId" integer,
    "cookingTime" text COLLATE pg_catalog."default",
    "utensilsRequired" jsonb,
    "description" text COLLATE pg_catalog."default",
    "cuisine" text COLLATE pg_catalog."default",
    CONSTRAINT "simpleRecipe_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS "simpleRecipe"."simpleRecipeYield"
(
    "id" integer NOT NULL,
    "recipeId" integer NOT NULL,
    "yield" jsonb NOT NULL,
    "readyToEat" boolean NOT NULL DEFAULT true,
    "mealKit" boolean NOT NULL DEFAULT true,
    CONSTRAINT "recipeServing_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS "simpleRecipe"."recipeYield_ingredientSachet"
(
    "recipeYieldId" integer NOT NULL,
    "ingredientSachetId" integer NOT NULL,
    CONSTRAINT "recipeYield_ingredientSachet_pkey" PRIMARY KEY ("recipeYieldId", "ingredientSachetId")
)
TABLESPACE pg_default;

--schema: unit
    --table: unit
    --table: unitConversion

CREATE SCHEMA IF NOT EXISTS "unit";

CREATE TABLE IF NOT EXISTS unit."unit"
(
    "id" integer NOT NULL,
    "name" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "unit_pkey" PRIMARY KEY (id),
    CONSTRAINT "unit_name_key" UNIQUE (name)
)
TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS unit."unitConversion"
(
    "id" integer NOT NULL,
    "inputUnitName" text COLLATE pg_catalog."default" NOT NULL,
    "outputUnitName" text COLLATE pg_catalog."default" NOT NULL,
    "defaultConversionFactor" jsonb,
    CONSTRAINT "unitConversion_pkey" PRIMARY KEY (id)
)
TABLESPACE pg_default;

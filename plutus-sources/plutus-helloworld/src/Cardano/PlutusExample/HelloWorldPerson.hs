{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Cardano.PlutusExample.HelloWorldPerson
  (
      person
    , PersonDetails(..)
    , helloWorldSerialised
    , helloWorldSBS
  ) where

import           Prelude hiding (($))

import           Cardano.Api.Shelley (PlutusScript (..), PlutusScriptV1)

import           Codec.Serialise
import qualified Data.ByteString.Short as SBS
import qualified Data.ByteString.Lazy  as LBS

import           Ledger               hiding (singleton)
import qualified Ledger.Typed.Scripts as Scripts
import qualified PlutusTx
import           PlutusTx.Prelude as P hiding (Semigroup (..), unless)

data PersonDetails = PersonDetails {
    pName :: P.ByteString
  , pDob  :: P.ByteString  
} deriving Show

PlutusTx.makeLift ''PersonDetails

person :: PersonDetails
person = PersonDetails { pName = "Sam Jones", pDob = "1974/12/23" }

{-# INLINABLE helloWorld #-}

helloWorld :: PersonDetails -> P.ByteString -> P.ByteString -> ScriptContext -> P.Bool
helloWorld thePerson datum redeemer context = 
    pName thePerson P.== datum     P.&& 
    pDob thePerson  P.== redeemer

{-
    As a ScriptInstance
-}

data HelloWorld
instance Scripts.ValidatorTypes HelloWorld where
    type instance DatumType HelloWorld = P.ByteString
    type instance RedeemerType HelloWorld = P.ByteString

helloWorldInstance :: Scripts.TypedValidator HelloWorld
helloWorldInstance = Scripts.mkTypedValidator @HelloWorld
    ($$(PlutusTx.compile [|| helloWorld ||]) `PlutusTx.applyCode` PlutusTx.liftCode person)
    $$(PlutusTx.compile [|| wrap ||])
  where
    wrap = Scripts.wrapValidator @P.ByteString @P.ByteString

{-
    As a Validator
-}

helloWorldValidator :: Validator
helloWorldValidator = Scripts.validatorScript helloWorldInstance


{-
    As a Script
-}

helloWorldScript :: Script
helloWorldScript = unValidatorScript helloWorldValidator

{-
    As a Short Byte String
-}

helloWorldSBS :: SBS.ShortByteString
helloWorldSBS =  SBS.toShort . LBS.toStrict $ serialise helloWorldScript

{-
    As a Serialised Script
-}

helloWorldSerialised :: PlutusScript PlutusScriptV1
helloWorldSerialised = PlutusScriptSerialised helloWorldSBS


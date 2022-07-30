abstract class FingerPrintStates{}

class FingerPrintInitialState extends FingerPrintStates{}

class FingerPrintChangeRefreshState extends FingerPrintStates{}

class FingerPrintSuccessState extends FingerPrintStates{}

class FingerPrintCancelState extends FingerPrintStates{}

class FingerPrintErrorState extends FingerPrintStates{
  final String error;
  FingerPrintErrorState(this.error);
}
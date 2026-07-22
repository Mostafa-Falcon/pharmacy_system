import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_system/app/core/bloc/base_bloc.dart';
import 'package:pharmacy_system/app/core/bloc/base_state.dart';

class TestEvent {
  const TestEvent();
}

class LoadTestData extends TestEvent {
  final String payload;
  const LoadTestData(this.payload);
}

class TestBloc extends BaseBloc<TestEvent, String> {
  TestBloc() : super() {
    on<LoadTestData>((event, emit) async {
      await handleOperation(emit, () async {
        return event.payload;
      });
    });
  }
}

void main() {
  group('BaseBloc', () {
    test('emits loading then success on handleOperation', () async {
      final bloc = TestBloc();

      bloc.add(const LoadTestData('success_data'));
      
      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<BaseState<String>>((s) => s.isLoading == true),
          predicate<BaseState<String>>((s) => s.data == 'success_data'),
        ]),
      );

      await bloc.close();
    });
  });
}

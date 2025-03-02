import java.util.Scanner;

public class IfElseExample {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Prompt the user to enter a number
        System.out.print("Enter a number: ");
        int number = scanner.nextInt();

        // Check if the number is positive or non-positive
        if (number > 0) {
            System.out.println("The number is positive.");
        } else {
            System.out.println("The number is zero or negative.");
        }

        System.out.println("End of the program.");
    }
    a
}
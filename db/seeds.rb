40.times  do
	Enrollment.create({
        student_id: Faker::Number.between(from: 1, to: 50),
        institution_id: Faker::Number.between(from: 1, to: 50),
        amount: Faker::Number.decimal(l_digits: 4, r_digits: 2),
        installments: Faker::Number.between(from: 1, to: 20),
        due_day: Faker::Number.between(from: 1, to: 31)
	})
end
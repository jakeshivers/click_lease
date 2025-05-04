# Full standalone Python script to generate mock finance data and write it to /data folder

import os
import pandas as pd
import random
import uuid
from faker import Faker
from datetime import datetime, timedelta

# Set up
fake = Faker()
random.seed(42)

# Output directory
base_dir = "../data"
os.makedirs(base_dir, exist_ok=True)

# Generate Applicants
def generate_applicants(n=50):
    industries = ['Retail', 'Construction', 'Healthcare', 'Food Services', 'Manufacturing']
    return pd.DataFrame([{
        'applicant_id': str(uuid.uuid4()),
        'business_name': fake.company(),
        'industry': random.choice(industries),
        'founded_date': fake.date_between(start_date='-10y', end_date='-1y'),
        'annual_revenue': round(random.uniform(100000, 5000000), 2),
        'num_employees': random.randint(1, 50)
    } for _ in range(n)])

# Generate Loan Applications
def generate_loan_applications(applicants_df, max_loans=3):
    loans = []
    for _, row in applicants_df.iterrows():
        for _ in range(random.randint(1, max_loans)):
            app_date = fake.date_between(start_date='-2y', end_date='today')
            credit_score = random.randint(500, 800)
            risk_band = 'Low' if credit_score > 700 else 'Moderate' if credit_score > 600 else 'High'
            loans.append({
                'application_id': str(uuid.uuid4()),
                'applicant_id': row['applicant_id'],
                'application_date': app_date,
                'loan_amount': round(random.uniform(5000, 50000), 2),
                'term_months': random.choice([12, 24, 36]),
                'purpose': random.choice(['Equipment', 'Inventory', 'Marketing', 'Expansion']),
                'status': random.choices(['approved', 'denied', 'pending'], weights=[0.6, 0.3, 0.1])[0],
                'credit_score': credit_score,
                'risk_band': risk_band
            })
    return pd.DataFrame(loans)

# Generate Repayments
def generate_repayments(loans_df):
    repayments = []
    for _, row in loans_df.iterrows():
        if row['status'] != 'approved':
            continue
        monthly_payment = row['loan_amount'] / row['term_months']
        start_date = row['application_date'] + timedelta(days=random.randint(30, 60))
        for i in range(row['term_months']):
            pay_date = start_date + timedelta(days=30 * i)
            if pay_date > datetime.today().date():
                break
            status = random.choices(['on_time', 'late', 'defaulted'], weights=[0.85, 0.1, 0.05])[0]
            repayments.append({
                'repayment_id': str(uuid.uuid4()),
                'application_id': row['application_id'],
                'payment_date': pay_date,
                'amount_paid': round(monthly_payment if status != 'defaulted' else 0, 2),
                'payment_status': status
            })
    return pd.DataFrame(repayments)

# Generate Credit Score Snapshots
def generate_credit_score_snapshots(applicants_df):
    snapshots = []
    for _, row in applicants_df.iterrows():
        for _ in range(random.randint(2, 6)):
            snapshots.append({
                'snapshot_id': str(uuid.uuid4()),
                'applicant_id': row['applicant_id'],
                'score_date': fake.date_between(start_date='-2y', end_date='today'),
                'credit_score': random.randint(500, 800),
                'score_source': random.choice(['Experian', 'Equifax'])
            })
    return pd.DataFrame(snapshots)

# Generate everything
applicants_df = generate_applicants()
loans_df = generate_loan_applications(applicants_df)
repayments_df = generate_repayments(loans_df)
snapshots_df = generate_credit_score_snapshots(applicants_df)

# Save to CSVs
applicants_df.to_csv(os.path.join(base_dir, "applicants.csv"), index=False)
loans_df.to_csv(os.path.join(base_dir, "loan_applications.csv"), index=False)
repayments_df.to_csv(os.path.join(base_dir, "repayments.csv"), index=False)
snapshots_df.to_csv(os.path.join(base_dir, "credit_score_snapshots.csv"), index=False)

# Confirm paths
os.listdir(base_dir)

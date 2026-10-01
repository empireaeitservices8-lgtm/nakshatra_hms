class Employee {
  final String id;
  final String name;
  final String role;
  final String department;
  final String email;
  final String phone;
  final String avatarInitials;
  final String joinDate;
  final String employeeCode;
  final bool isPresent;

  const Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.email,
    required this.phone,
    required this.avatarInitials,
    required this.joinDate,
    required this.employeeCode,
    this.isPresent = false,
  });
}

class AttendanceRecord {
  final DateTime date;
  final String? checkIn;
  final String? checkOut;
  final String status; // present, absent, half-day, leave

  const AttendanceRecord({
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
  });
}

class LeaveRequest {
  final String type;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
  final String status; // pending, approved, rejected
  final DateTime appliedOn;

  const LeaveRequest({
    required this.type,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.status,
    required this.appliedOn,
  });
}

// Sample data
class SampleData {
  static const List<Employee> employees = [
    Employee(
      id: '1',
      name: 'Arjun Krishnan',
      role: 'Store Manager',
      department: 'Operations',
      email: 'arjun.k@nakshatra.com',
      phone: '+91 98765 43210',
      avatarInitials: 'AK',
      joinDate: '15 Jan 2021',
      employeeCode: 'NGD-001',
      isPresent: true,
    ),
    Employee(
      id: '2',
      name: 'Priya Menon',
      role: 'Senior Jewellery Designer',
      department: 'Design',
      email: 'priya.m@nakshatra.com',
      phone: '+91 97654 32109',
      avatarInitials: 'PM',
      joinDate: '03 Mar 2020',
      employeeCode: 'NGD-002',
      isPresent: true,
    ),
    Employee(
      id: '3',
      name: 'Rahul Nair',
      role: 'Sales Executive',
      department: 'Sales',
      email: 'rahul.n@nakshatra.com',
      phone: '+91 96543 21098',
      avatarInitials: 'RN',
      joinDate: '10 Jul 2022',
      employeeCode: 'NGD-003',
      isPresent: false,
    ),
    Employee(
      id: '4',
      name: 'Deepa Pillai',
      role: 'HR Executive',
      department: 'Human Resources',
      email: 'deepa.p@nakshatra.com',
      phone: '+91 95432 10987',
      avatarInitials: 'DP',
      joinDate: '22 Sep 2019',
      employeeCode: 'NGD-004',
      isPresent: true,
    ),
    Employee(
      id: '5',
      name: 'Vijay Kumar',
      role: 'Goldsmith',
      department: 'Craft',
      email: 'vijay.k@nakshatra.com',
      phone: '+91 94321 09876',
      avatarInitials: 'VK',
      joinDate: '01 Feb 2018',
      employeeCode: 'NGD-005',
      isPresent: true,
    ),
    Employee(
      id: '6',
      name: 'Lakshmi Devi',
      role: 'Accounts Manager',
      department: 'Finance',
      email: 'lakshmi.d@nakshatra.com',
      phone: '+91 93210 98765',
      avatarInitials: 'LD',
      joinDate: '17 Nov 2020',
      employeeCode: 'NGD-006',
      isPresent: false,
    ),
  ];
}
